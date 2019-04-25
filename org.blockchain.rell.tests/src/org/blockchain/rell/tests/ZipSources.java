package org.blockchain.rell.tests;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class ZipSources {
	static final String userFolder = System.getProperty("user.dir");
	
	public static List<String> getZipData(String zipName) {
		String pathToZip = userFolder + File.separator + zipName;
		
		List<String> snnipets =new ArrayList<>();
		
		try {
			@SuppressWarnings("resource")
			ZipFile zipFile = new ZipFile(pathToZip);
			Enumeration<? extends ZipEntry> zipEntries = zipFile.entries();
			
			String line;
			
			while (zipEntries.hasMoreElements()) {
				ZipEntry zipEntry = (ZipEntry) zipEntries.nextElement();
				
	            try (   InputStream inputStream = zipFile.getInputStream(zipEntry);
	                    BufferedReader bufferedReader = new BufferedReader(
	                            new InputStreamReader(inputStream, StandardCharsets.UTF_8.name())
	                    )
	            ) {
	            	StringBuilder stringBuilder = new StringBuilder();
	                while ((line = bufferedReader.readLine()) != null) {
	                    stringBuilder.append(line);
	                }
	                
	                snnipets.add(stringBuilder.toString());
	            }	
			}	
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return snnipets;
	}
}
