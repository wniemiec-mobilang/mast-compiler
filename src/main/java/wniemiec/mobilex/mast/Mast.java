package wniemiec.mobilex.mast;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import org.apache.commons.io.FileUtils;

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
    private final String appName;
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
     * @param       mobilang Mobilang XML file
     * @param       output Path where compiler output will be put
     * 
     * @throws      IOException If mobilang file cannot be read
     */
    public Mast(Path mobilang, Path output) throws IOException {
        this.mobilangFilePath = mobilang;
        this.outputLocationPath = buildOutputLocation(mobilang, output);
        appName = extractAppName(mobilang);
    }


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    private static Path buildOutputLocation(Path mobilang, Path output) 
    throws IOException {
        TextFileManager txtManager = new TextFileManager(
            mobilang, 
            StandardCharsets.UTF_8
        );
        String appName = txtManager.getFileLineThatContains("\"application_name\":");

        if (appName == null) {
            throw new IllegalStateException("application_name not found in properties");
        }

        Path appFolder = Path.of(appName.split(":")[1].strip().replace("\"", "").replace(",", ""));

        return output.resolve(appFolder);
    }

    private static String extractAppName(Path mobilangFilePath) {
        String filename = mobilangFilePath.getFileName().toString();
        int indexOfFirstDot = filename.indexOf(".");
        
        return filename.substring(0, indexOfFirstDot);
    }

    public Path run() throws IOException {
        setUpOutput();
        setUpTerminal();
        setUpMastLocation();
        setUpJavaScriptLocation();
        runMakeAll();
        runMakeCompilation();
        runHtmlParser();
        runCssParser();
        runJavaScriptParser();
        runMakeClean();

        return astFilePath;
    }

    private void setUpOutput() throws IOException {
        Files.createDirectories(outputLocationPath);
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

    private void runMakeCompilation() throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            mastLocation.toString(), 
            "compilation", 
            "file=" + mobilangFilePath.toString(), 
            "output=" + outputLocationPath.toString()
        );

        astFilePath = buildAstFilePath(appName);
    }

    private Path buildAstFilePath(String appName) {
        return outputLocationPath
            .resolve("ast")
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
