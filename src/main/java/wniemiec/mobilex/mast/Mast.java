package wniemiec.mobilex.mast;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import wniemiec.io.java.Consolex;
import wniemiec.io.java.JarFileManager;
import wniemiec.io.java.StandardTerminalBuilder;
import wniemiec.io.java.Terminal;
import wniemiec.io.java.TextFileManager;


/**
 * Responsible for managing MAST compiler pipeline.
 */
public class Mast {

    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private final Path mobilangFilePath;
    private final Path outputLocationPath;
    private Path mastLocation;
    private Path javascriptLocation;
    private Path astFilePath;
    private Terminal terminal;


    //-------------------------------------------------------------------------
    //		Constructor
    //-------------------------------------------------------------------------
    /**
     * Manager for MAST compiler pipeline.
     * 
     * @param       mobilangFilePath MobiLang XML file
     * @param       outputLocationPath Path where compiler output will be put
     */
    public Mast(Path mobilangFilePath, Path outputLocationPath) {
        this.mobilangFilePath = mobilangFilePath;
        this.outputLocationPath = outputLocationPath;
    }


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    public Path run() throws IOException {
        String appName = extractAppName();

        setUpTerminal();
        setUpMastLocation();
        setUpJavaScriptLocation();
        runMakeAll();
        runMakeCompilation(appName);
        runHtmlParser();
        runCssParser();
        runJavaScriptParser();
        runMakeClean();

        return astFilePath;
    }

    private String extractAppName() throws IOException {
        TextFileManager txtManager = new TextFileManager(mobilangFilePath, StandardCharsets.UTF_8);
        String appName = txtManager.getFileLineThatContains("\"application_name\":");

        if (appName == null) {
            throw new IllegalStateException("application_name not found in properties");
        }

        return appName.split(":")[1].strip().replace("\"", "").replace(",", "");
    }

    private void setUpTerminal() {
        terminal = StandardTerminalBuilder
            .getInstance()
            .outputHandler(Consolex::writeDebug)
            .outputErrorHandler(Consolex::writeWarning)
            .build();
    }

    private void setUpMastLocation() throws IOException {
        Path baseDir = buildBaseDir();

        mastLocation = baseDir
            .resolve("cpp")
            .resolve("wniemiec")
            .resolve("mobilex")
            .resolve("mast");
    }

    private void setUpJavaScriptLocation() throws IOException {
        Path baseDir = buildBaseDir();

        javascriptLocation = baseDir.resolve("javascript");
    }

    private static Path buildBaseDir() throws IOException {
        if (!isJarFile()) {
            return App.getAppRootPath();
        }

        Path tmpDir = Path.of(System.getProperty("java.io.tmpdir"));
        JarFileManager jarManager = new JarFileManager(App.getAppRootPath());

        return jarManager.extractTo(tmpDir);
    }

    private static boolean isJarFile() {
        return JarFileManager.isJarFile(App.getAppRootPath());
    }

    private void runMakeAll() throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            mastLocation.toString()
        );
    }

    private void runMakeCompilation(String appName) throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            mastLocation.toString(), 
            "compilation", 
            "file=" + mobilangFilePath, 
            "output=" + outputLocationPath.resolve(appName), 
            "name=" + appName
        );

        astFilePath = buildAstFilePath(appName);
    }

    private Path buildAstFilePath(String appName) {
        return outputLocationPath
            .resolve(appName)
            .resolve(appName + ".dot");
    }

    private void runHtmlParser() throws IOException {
        terminal.exec(
            "node", 
            javascriptLocation.resolve("html-parser").toString(),
            astFilePath.toString()
        );
    }

    private void runCssParser() throws IOException {
        terminal.exec(
            "node", 
            javascriptLocation.resolve("css-parser").toString(),
            astFilePath.toString()
        );
    }

    private void runJavaScriptParser() throws IOException {
        terminal.exec(
            "node", 
            javascriptLocation.resolve("javascript-parser").toString(),
            astFilePath.toString()
        );
    }

    private void runMakeClean() throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            mastLocation.toString(),
            "clean"
        );
    }
}
