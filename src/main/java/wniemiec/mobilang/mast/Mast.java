package wniemiec.mobilang.mast;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Path;
import wniemiec.mobilang.mast.utils.Shell;


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
            .getAppLocation()
            .getParent()
            .getParent()
            .getParent()
            .getParent()
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
        Shell shell = new Shell(MAST_LOCATION, true);
        String appName = extractAppName();

        makeAll(shell);
        makeCompilation(shell, appName);

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

    private void makeAll(Shell shell) throws IOException {
        shell.exec(
            "make", 
            "-C", 
            MAST_LOCATION.toString()
        );
    }

    private void makeCompilation(Shell shell, String appName) throws IOException {
        shell.exec(
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
