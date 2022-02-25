package wniemiec.mobilang.mast;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import wniemiec.io.java.Consolex;
import wniemiec.io.java.LogLevel;


/**
 * Application point entry. Responsible for parsing CLI arguments and running 
 * MAST compiler.
 */
public class App {
    
    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private static final String LBL_MOBILANG;
    private static final String LBL_OUTPUT;
    private static final String LBL_VERBOSE;
    private static Path mobilangFilePath;
    private static Path outputLocationPath;


    //-------------------------------------------------------------------------
    //		Initialization block
    //-------------------------------------------------------------------------
    static {
        LBL_MOBILANG = "mobilang";
        LBL_OUTPUT = "output";
        LBL_VERBOSE = "verbose";
    }


    //-------------------------------------------------------------------------
    //		Main
    //-------------------------------------------------------------------------
    public static void main(String[] args) {
        try {
            parseArgs(args);
            runMast();
        }
        catch (IllegalArgumentException e) {
            Consolex.writeError("Invalid cmd args: " + e.getMessage());
        }
        catch (Exception e) {
            Consolex.writeError("Fatal error: " + e.getMessage());
        }
    }


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    private static void parseArgs(String[] args) throws ParseException {
        CommandLine cmd = buildCmd(args);
        
        validateArgs(cmd);
        
        mobilangFilePath = getMobilangCliArg(cmd);
        outputLocationPath = getOutputCliArg(cmd);
    }

    private static CommandLine buildCmd(String[] args) throws ParseException {
        Options options = buildCliOptions();
        CommandLineParser parser = new DefaultParser();
        
        return parser.parse(options, args);
    }


    private static Options buildCliOptions() {
        Options options = new Options();

        options.addOption(LBL_MOBILANG, true, "MobiLang XML file");
        options.addOption(LBL_OUTPUT, true, "Output location");
        options.addOption(LBL_VERBOSE, false, "Display debug messages");
        
        return options;
    }

    private static void validateArgs(CommandLine cmd) {
        if (!cmd.hasOption(LBL_MOBILANG)) {
            throw new IllegalArgumentException(LBL_MOBILANG + " is missing");
        }

        if (!cmd.hasOption(LBL_OUTPUT)) {
            throw new IllegalArgumentException(LBL_OUTPUT + " is missing");
        }
    }

    private static void checkVerboseOption(CommandLine cmd) {
        if (cmd.hasOption(LBL_VERBOSE)) {
            Consolex.setLoggerLevel(LogLevel.DEBUG);
        }
    }

    private static Path getMobilangCliArg(CommandLine cmd) {
        String mobilangCliArg = cmd.getOptionValue(LBL_MOBILANG);

        return normalizePath(Path.of(mobilangCliArg));
    }
    
    private static Path normalizePath(Path path) {
        return path.toAbsolutePath().normalize();
    }

    private static Path getOutputCliArg(CommandLine cmd) {
        String outputCliArg = cmd.getOptionValue(LBL_OUTPUT);

        return normalizePath(Path.of(outputCliArg));
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
    public static Path getAppRootPath() {
        Path binRootPath = getBinRootPath();

        if (isDevelopmentEnvironment(binRootPath)) {
            return binRootPath
                .getParent()
                .getParent()
                .resolve("src")
                .resolve("main");
        }
        
        return binRootPath;
    }

    private static Path getBinRootPath() {
        return getAppBinPath()
            .normalize()
            .toAbsolutePath()
            .getParent()
            .getParent()
            .getParent()
            .getParent();
    }

    private static Path getAppBinPath() {
		return urlToPath(App.class.getResource("App.class"));
	}
	
	private static Path urlToPath(URL url) {
		return new File(url.getPath()).toPath();
	}

    private static boolean isDevelopmentEnvironment(Path binRootPath) {
        return binRootPath
            .getFileName()
            .toString()
            .equals("classes");
    }
}
