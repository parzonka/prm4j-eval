/*
 * Copyright (c) 2012 Mateusz Parzonka, Eric Bodden
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 * Mateusz Parzonka - initial API and implementation
 */
package mop;

import java.util.logging.FileHandler;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

import org.apache.commons.math3.stat.descriptive.SummaryStatistics;

/**
 * Logs memory consumption to file. Activated by system property "prm4jeval.memoryLogging".
 */
public class MemoryLogger {

    private final static boolean MEMORY_LOGGING = Boolean.parseBoolean(getSystemProperty("prm4jeval.memoryLogging",
	    "false"));

    private SummaryStatistics memStats;
    private long timestamp = 0L;

    private Logger logger;

    private String benchmark;
    private String parametricProperty;
    private int invocation;

    // Trying to track down NaNs which appeared in mean and max.
    private int NaNcount = 0;

    MemoryLogger() {
	if (MEMORY_LOGGING) {
	    memStats = new SummaryStatistics();
	    String outputPath = getMandatorySystemProperty("prm4jeval.outputfile") + ".mem.log";
	    System.out.println("Memory logging activated. Output path: " + outputPath);
	    benchmark = getMandatorySystemProperty("prm4jeval.benchmark");
	    parametricProperty = getMandatorySystemProperty("prm4jeval.parametricProperty");
	    invocation = Integer.parseInt(getMandatorySystemProperty("prm4jeval.invocation"));
	    logger = getFileLogger(outputPath);
	} else {
	    System.out.println("Memory logging not activated.");
	}
    }

    /**
     * Registers the memory consumption every 100 events. Flag MEMORY_LOGGING has to be activated.
     */
    public void logMemoryConsumption() {
	if (MEMORY_LOGGING && timestamp++ % 100 == 0) {
	    double memoryConsumption = (((double) (Runtime.getRuntime().totalMemory() / 1024) / 1024) - ((double) (Runtime
		    .getRuntime().freeMemory() / 1024) / 1024));
	    // filter NaNs
	    if (memoryConsumption != Double.NaN) {
		memStats.addValue(memoryConsumption);
	    } else {
		NaNcount++;
	    }
	}
    }

    /**
     * Registers the memory consumption independent of any internal event counter or timestamp. Flag MEMORY_LOGGING has
     * to be activated.
     */
    public void reallyLogMemoryConsumption() {
	if (MEMORY_LOGGING) {
	    double memoryConsumption = (((double) (Runtime.getRuntime().totalMemory() / 1024) / 1024) - ((double) (Runtime
		    .getRuntime().freeMemory() / 1024) / 1024));
	    // filter NaNs
	    if (memoryConsumption != Double.NaN) {
		memStats.addValue(memoryConsumption);
	    } else {
		NaNcount++;
	    }
	}
    }

    /**
     * Writes memory consumption (mean and max), number of counted events and number of violations to disk.
     * => it benchm paramPropert iter mean-MB___ max-MB____ #events #viola
     * => 00 avrora SafeIterator iter 126.242460 205.088867 1367408 103521
     */
    public void writeToFile(int violationsCount) {
	if (MEMORY_LOGGING) {
	    logger.log(
		    Level.INFO,
		    String.format("%02d %s %s iter %f %f %d %d", invocation, benchmark, parametricProperty,
			    memStats.getMean(), memStats.getMax(), timestamp, violationsCount));

	    System.out.println("Counted " + timestamp + " events.");

	    // Trying to track down NaNs which appeared in mean and max.
	    if (NaNcount > 0) {
		System.out.println("Counted " + NaNcount + " NaN-measurements of memory consumption.");
	    }
	    // reset
	    memStats.clear();
	    timestamp = 0L;
	}
    }

    /**
     * A simple file logger which outputs only the message.
     *
     * @param fileName
     *            path to the output file
     * @return the logger
     */
    private static Logger getFileLogger(String fileName) {
	final Logger logger = Logger.getLogger(fileName);
	try {
	    logger.setUseParentHandlers(false);
	    Handler handler = new FileHandler(fileName, true);
	    handler.setFormatter(new Formatter() {
		@Override
		public String format(LogRecord record) {
		    return record.getMessage() + "\n";
		}
	    });
	    logger.addHandler(handler);
	} catch (Exception e) {
	    throw new RuntimeException(e);
	}
	return logger;
    }

    static String getSystemProperty(String key, String defaultValue) {
	final String value = System.getProperty(key);
	return value != null ? value : defaultValue;
    }

    static String getMandatorySystemProperty(String key) {
	final String value = System.getProperty(key);
	if (value == null) {
	    throw new RuntimeException("System property [" + key + "] is mandatory but not defined!");
	}
	return value;
    }

}
