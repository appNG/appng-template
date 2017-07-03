package org.appng.template;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.io.IOUtils;

/**
 * Extracts the folders resources, xsl and conf of the template-jar to a destination folder.
 * 
 * @author Matthias Müller
 * 
 */
public class Extractor {

	private static final String INCLUDE_PATTERN = "resources/.*|xsl/.*|conf/.*";
	private static final String DEFAULT_THEME_CSS = "resources/tools_stylesheet_default_theme.css";

	public static void main(String[] args) throws IOException {
		if (args.length < 2) {
			System.out.println("Usage: org.appng.template.Extractor <source-template.jar> <target-folder>");
			return;
		}
		List<String> excludes = new ArrayList<String>();
		if (args.length > 2) {
			for (int i = 2; i < args.length; i++) {
				excludes.add(args[i]);
			}
		} else {
			excludes.add(DEFAULT_THEME_CSS);
		}

		String sourceFile = args[0];
		String targetFolder = args[1];

		System.out.println("Extracting " + sourceFile + " to " + targetFolder);
		long start = System.currentTimeMillis();

		ZipFile templateArchive = null;
		try {
			templateArchive = new ZipFile(sourceFile);

			Enumeration<? extends ZipEntry> entries = templateArchive.entries();
			List<ZipEntry> files = new ArrayList<ZipEntry>();
			while (entries.hasMoreElements()) {
				ZipEntry zipEntry = entries.nextElement();
				if (!zipEntry.isDirectory() && zipEntry.getName().matches(INCLUDE_PATTERN)) {
					files.add(zipEntry);
				}
			}
			Collections.sort(files, new Comparator<ZipEntry>() {
				public int compare(ZipEntry z1, ZipEntry z2) {
					File f1 = new File(z1.getName());
					File f2 = new File(z2.getName());
					int result = f1.getParent().compareTo(f2.getParent());
					return (0 == result) ? f1.getName().compareTo(f2.getName()) : result;
				}
			});

			for (ZipEntry file : files) {
				String name = file.getName();
				if (excludes.contains(name)) {
					System.out.println("skipping " + name);
				} else {
					InputStream is = templateArchive.getInputStream(file);
					File targetFile = new File(targetFolder, name);
					targetFile.getParentFile().mkdirs();
					OutputStream out = new FileOutputStream(targetFile);
					IOUtils.copy(is, out);
					is.close();
					out.close();
					System.out.println(targetFile.getPath() + " (" + targetFile.length() + " bytes)");
				}
			}
			long end = System.currentTimeMillis();
			System.out.println("...done! Duration: " + (end - start) + "ms");
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				templateArchive.close();
			} catch (IOException e) {/* ignore */
			}
		}
	}
}