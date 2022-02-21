package wniemiec.mobilang.mast;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import wniemiec.io.java.Consolex;


/**
 * Application point entry. Responsible for parsing CLI arguments and running 
 * MAST compiler.
 */
public class App {
    
    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private static Path mobilangFilePath;
    private static Path outputLocationPath;


    //-------------------------------------------------------------------------
    //		Main
    //-------------------------------------------------------------------------
    public static void main(String[] args) {
        try {
            parseArgs(args);
            runMast();
        }
        catch (InvalidPathException e) {
            Consolex.writeError("Invalid output location: " + e.getMessage());
        }
        catch (Exception e) {
            Consolex.writeError("Fatal error");
            e.printStackTrace();
        }
    }


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    private static void parseArgs(String[] args) {
        validateArgs(args);

        mobilangFilePath = normalizePath(Path.of(args[0]));
        outputLocationPath = normalizePath(Path.of(args[1]));
    }

    private static Path normalizePath(Path path) {
        return path.toAbsolutePath().normalize();
    }

    private static void validateArgs(String[] args) {
        if (args.length < 2) {
            Consolex.writeError("Missing args! Correct usage: <mobilang_file> <output_location>");
            System.exit(-1);
        }
    }

    private static void runMast() throws IOException {
        Mast mast = new Mast(
            mobilangFilePath, 
            outputLocationPath
        );

        mast.run();
    }


    //-------------------------------------------------------------------------
    //		Getters
    //-------------------------------------------------------------------------
    public static Path getAppLocation() {
        Path appBinPath = getAppBinPath();
        
        return appBinPath.normalize().toAbsolutePath();
    }

    private static Path getAppBinPath() {
		return urlToPath(App.class.getResource("App.class"));
	}
	
	private static Path urlToPath(URL url) {
		return new File(url.getPath()).toPath();
	}
}
