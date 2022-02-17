package wniemiec.mobilang.mast.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


/**
 * Responsible for running shell commands.
 */
public class Shell {

    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private final Path workingDirectory;
    private final boolean displayOutput;
    private final Runtime runtime;
    private String output;
    private String errorOutput;


    //-------------------------------------------------------------------------
    //		Constructors
    //-------------------------------------------------------------------------
    /**
     * Run shell commands. Using this constructor, working directory will be
     * user current directory and output will be displayed on console.
     */
    public Shell() {
        this(null, true);
    }

    /**
     * Run shell commands.
     * 
     * @param       workingDirectory Working directory
     * @param       displayOutput True if output should be printed on console;
     * false otherwise.
     */
    public Shell(Path workingDirectory, boolean displayOutput) {
        this.workingDirectory = workingDirectory;
        this.displayOutput = displayOutput;
        runtime = Runtime.getRuntime();
        clean();
    }


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    /**
     * Erases Shell output.
     */
    public void clean() {
        output = "";
        errorOutput = "";
    }

    /**
     * Run Shell with some commands.
     * 
     * @param       commands Shell commands
     * 
     * @throws      IOException If Shell process cannot be created
     */
    public void exec(String... commands) throws IOException {
        Process process = runShell(parseCommands(commands));

        readOutput(process);
        readErrorOutput(process); 
    }

    private String[] parseCommands(String[] commands) {
        if (workingDirectory == null) {
            return commands;
        }

        List<String> parsedCommand = new ArrayList<>();

        //parsedCommand.add("cd " + workingDirectory.toAbsolutePath().normalize().toString());
        //parsedCommand.add(workingDirectory.toAbsolutePath().normalize().toString());
        parsedCommand.addAll(Arrays.asList(commands));

        return parsedCommand.toArray(new String[] {});
    }

    private Process runShell(String... commands) throws IOException {
        return runtime.exec(
            commands, 
            null, 
            null
        );
    }

    private static Path getCurrentDirectory() {
        return Path.of(System.getProperty("user.dir"));
    }

    private void readOutput(Process process) throws IOException {
        output = readProcessInputStream(process.getInputStream());
    }

    private String readProcessInputStream(InputStream stream) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
        StringBuilder builder = new StringBuilder();
        String line = null;

        while ((line = reader.readLine()) != null) {
            builder.append(line);
            builder.append(System.getProperty("line.separator"));

            if (displayOutput) {
                System.out.println(line);
            }
        }

        return builder.toString();
    }

    private void readErrorOutput(Process process) throws IOException {
        errorOutput = readProcessInputStream(process.getErrorStream());
    }
    
    public boolean hasError() {
        return !errorOutput.isBlank();
    }


    //-------------------------------------------------------------------------
    //		Getters
    //-------------------------------------------------------------------------
    public String getOutput() {
        return output;
    }

    public String getErrorOutput() {
        return errorOutput;
    }
}
