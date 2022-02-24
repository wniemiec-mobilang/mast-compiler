package wniemiec.mobilang.mast;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Path;

import wniemiec.io.java.Consolex;
import wniemiec.io.java.StandardTerminalBuilder;
import wniemiec.io.java.Terminal;


/**
 * Responsible for managing MAST compiler pipeline.
 */
public class Mast {

    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private static final Path MAST_LOCATION;
    private final Path mobilangFilePath;
    private final Path outputLocationPath;


    //-------------------------------------------------------------------------
    //		Initialization block
    //-------------------------------------------------------------------------
    static {
        MAST_LOCATION = App
            .getAppRootPath()
            .resolve("c")
            .resolve("mast");
    }


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
        Terminal terminal = StandardTerminalBuilder
            .getInstance()
            .outputHandler(Consolex::writeInfo)
            .outputErrorHandler(Consolex::writeError)
            .build();
        String appName = extractAppName();

        makeAll(terminal);
        makeCompilation(terminal, appName);

        return outputLocationPath.resolve(appName + ".dot");
    }

    private String extractAppName() throws IOException {
        String appName = null;

        try (BufferedReader buffer = new BufferedReader(new FileReader(mobilangFilePath.toFile()))) {
            for(String line = buffer.readLine(); line != null; line = buffer.readLine()) {
                if (line.contains("\"application_name\":")) {
                    appName = line.split(":")[1].strip();
                    break;
                }
            }
        }

        if (appName == null) {
            throw new IllegalStateException("application_name not found in properties");
        }

        return appName;
    }

    private void makeAll(Terminal terminal) throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            MAST_LOCATION.toString()
        );
    }

    private void makeCompilation(Terminal terminal, String appName) throws IOException {
        terminal.exec(
            "make", 
            "-C", 
            MAST_LOCATION.toString(), 
            "compilation", 
            "file=" + mobilangFilePath, 
            "output=" + outputLocationPath, 
            "name=" + appName
        );
    }
}
