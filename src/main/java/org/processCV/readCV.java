package org.processCV;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.apache.tika.exception.TikaException;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.parser.Parser;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.SAXException;

public class readCV {

    public String read(String cvFilePath) {
        try {
            FileInputStream inputStream = new FileInputStream(new File(cvFilePath));
            Parser parser = new AutoDetectParser();

            // -1 disables the character limit (default is 100k which truncates large CVs)
            BodyContentHandler handler = new BodyContentHandler(-1);
            Metadata metadata = new Metadata();
            ParseContext context = new ParseContext();

            parser.parse(inputStream, handler, metadata, context);

            String[] metadataNames = metadata.names();
            for (String name : metadataNames) System.out.println(name + ": " + metadata.get(name));

            String raw = handler.toString();
            System.out.println("Extracted CV content:\n" + raw);

            // Normalize line endings, collapse excessive blank lines
            String[] lines = raw.split("\\r?\\n");
            StringBuilder sb = new StringBuilder();
            int blankCount = 0;

            for (String line : lines) {
                String trimmed = line.trim();
                if (trimmed.isEmpty()) {
                    blankCount++;
                    // Allow max one consecutive blank line
                    if (blankCount <= 1) sb.append("\n");
                } else {
                    blankCount = 0;
                    sb.append(trimmed).append("\n");
                }
            }

            return sb.toString().trim();

        } catch (SAXException ex) {
            System.out.println("SAXException error: " + ex);
        } catch (IOException ex) {
            System.out.println("IOException error: " + ex);
        } catch (TikaException ex) {
            System.out.println("TikaException error: " + ex);
        }
        return "";
    }

    public boolean isAllCapsAndSpaces(String text) {
        return text.matches("[A-Z\\s]+");
    }
}
