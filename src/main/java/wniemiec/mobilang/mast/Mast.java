package wniemiec.mobilang.mast;

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
        runTerminal(appName);

        return buildAstFilePath(appName);
    }

    private Path buildAstFilePath(String appName) {
        return outputLocationPath
            .resolve(appName)
            .resolve("ast")
            .resolve(appName + ".dot");
    }

    private String extractAppName() throws IOException {
        TextFileManager txtManager = new TextFileManager(mobilangFilePath, StandardCharsets.UTF_8);
        String appName = txtManager.getFileLineThatContains("\"application_name\":");

        if (appName == null) {
            throw new IllegalStateException("application_name not found in properties");
        }

        return appName.split(":")[1].strip().replace("\"", "");
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
            .resolve("c")
            .resolve("mast");
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

    private void runTerminal(String appName) throws IOException {
        makeAll();
        makeCompilation(appName);
    }

    private void makeAll() throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            mastLocation.toString()
        );
    }

    private void makeCompilation(String appName) throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            mastLocation.toString(), 
            "compilation", 
            "file=" + mobilangFilePath, 
            "output=" + outputLocationPath.resolve(appName).resolve("ast"), 
            "name=" + appName
        );
    }
}
