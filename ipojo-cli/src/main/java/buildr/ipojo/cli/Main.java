package buildr.ipojo.cli;

import java.io.File;
import java.io.FileInputStream;
import org.apache.felix.ipojo.manipulator.Pojoization;

public class Main
{
  public static void main( final String[] args )
  {
    if( 4 != args.length )
    {
      System.err.println("Usage: <input_file_name> <output_file_name> <metadata_file_name> <print_trace_messages?>");
      System.exit( 42 );
    }
    final String inputFilename = args[0];
    final String outputFilename = args[1];
    final String metadataFilename = args[2];
    final boolean printTraceMessage = args[3].equals( "true" );
    boolean inError;

    try
    {
      final Pojoization pojoizer = new Pojoization();
      pojoizer.setUseLocalXSD();
      pojoizer.pojoization( new File( inputFilename ),
                            new File( outputFilename ),
                            new FileInputStream( metadataFilename ) );
      if( printTraceMessage )
      {
        for( final Object message : pojoizer.getWarnings() )
        {
          System.out.println( "Pojoizer Warning: " + message );
        }
      }

      inError = pojoizer.getWarnings().size() != 0;
      for( final Object message : pojoizer.getWarnings() )
      {
        System.err.println( "Pojoizer Error: " + message );
      }
    }
    catch( final Exception e )
    {
      e.printStackTrace( System.err );
      inError = true;
    }

    System.exit( inError ? 1 : 0 );
  }
}
