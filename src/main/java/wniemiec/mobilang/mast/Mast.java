package wniemiec.mobilang.mast;

import java.io.IOException;
import java.nio.file.Path;
import wniemiec.mobilang.mast.utils.Shell;


public class Mast {

    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private static final Path MAST_LOCATION;
    private final Path mobilangFilePath;
    private final Path outputLocationPath;
    private final String filename;


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
    public Mast(Path mobilangFilePath, Path outputLocationPath, String filename) {
        this.mobilangFilePath = mobilangFilePath;
        this.outputLocationPath = outputLocationPath;
        this.filename = filename;
    }


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    public void run() throws IOException {
        Shell shell = new Shell(MAST_LOCATION, true);

        shell.exec("make", "-C", MAST_LOCATION.toString());
        shell.exec("make", "-C", MAST_LOCATION.toString(), "compilation", "file=" + mobilangFilePath, "output=" + outputLocationPath, "name=" + filename);
    }
}
