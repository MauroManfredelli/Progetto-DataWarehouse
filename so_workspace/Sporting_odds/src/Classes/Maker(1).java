package Classes;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

public class Maker {
	
	protected String dataset_fd, dataset_td, dataset_atpmds, dataset_atpmt, dataset_countries, dataset_cities;
	protected String csvSplitBy;
	protected String same_football, same_tennis, etl_path, esdb_path, root_path, fd_path;
	protected String cleaned_esdb, cleaned_fd, cleaned_fd_div, fd_div, cleaned_td, cleaned_atpmt, cleaned_atpmds, cleaned_path, cleaned_countries, cleaned_cities, pf_syn_file, pf_syn_team_file, cf_syn_file;
	protected HashMap<String,String> pf_syn_map, pf_syn_team_map, cf_syn_map;
	
	public Maker () {
		try {
			BufferedReader br = new BufferedReader(new FileReader("data/basedir.txt"));
			root_path = br.readLine();
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		dataset_fd = root_path+"dataset\\Football-data\\matches_fd.csv";
		fd_div = root_path+"dataset\\Football-data\\divisions_fd.csv";
		dataset_td = root_path+"dataset\\Tennis-data\\matches_td.csv";
		dataset_atpmt = root_path+"dataset\\ATP Men's Tour\\matches_atpmt.csv";
		dataset_atpmds = root_path+"dataset\\ATP Matches Dataset\\matches_atpmds.csv";
		csvSplitBy = "," ;
		etl_path = root_path+"etl\\csv\\";
		esdb_path = root_path+"dataset\\European Soccer Database\\csv\\";
		fd_path = root_path+"dataset\\Football-data\\";
		cleaned_esdb = etl_path + "matches_esbd_cleaned.csv";
		cleaned_fd = etl_path + "matches_fd_cleaned.csv";
		cleaned_fd_div = etl_path + "divisions_fd_cleaned.csv";
		cleaned_td = etl_path + "matches_td_cleaned.csv";
		cleaned_atpmt = etl_path + "matches_atpmt_cleaned.csv";
		cleaned_atpmds = etl_path + "matches_atpmds_cleaned.csv";
		cleaned_countries = etl_path + "countries_cleaned.csv";
		dataset_countries = root_path +"dataset\\Countries\\countries.csv";
		dataset_cities = root_path +"dataset\\Cities\\cities.csv";
		cleaned_cities = etl_path + "cities_cleaned.csv";
		pf_syn_map = new HashMap<String,String> ();
		pf_syn_team_map = new HashMap<String,String> ();
		pf_syn_file = etl_path + "created/participants_football_synonyms.csv";
		pf_syn_team_file = etl_path + "created/participants_football_teams_synonyms.csv";
		cf_syn_file = etl_path +"created/competitions_football_synonyms.csv";
		cf_syn_map = new HashMap<String,String> ();
	}
	
	public void integrate (String file1, int col1, String file2, int col2, String file3, String header_final, String file_same, String [] write_same, String [] write1, String [] write2, String invoker) {
			PrintWriter wr_same=null;
			PrintWriter wr_final=null;
			BufferedReader br1=null;
			BufferedReader br2=null;
			HashMap <String, Object> matches = new HashMap <String, Object>();
			try {
			 br1 = new BufferedReader(new FileReader(file1));
		     wr_same = new PrintWriter(new File(file_same));
		     wr_same.append("name_1,name_2\n");
		     wr_final = new PrintWriter(new File(file3));
		     wr_final.append(header_final);
			} catch (FileNotFoundException e) {
		        e.printStackTrace();
			}
		    String line1 = "";
		    try {
			     line1 = br1.readLine();
			     while ((line1 = br1.readLine()) != null) {
			    	 String cols1 [] = line1.split(csvSplitBy);
			    	 String name1 = cols1[col1];
			    	 br2 = new BufferedReader(new FileReader(file2));
			    	 String line2 = br2.readLine();
			    	 boolean match=false;
			    	 int n_line2=1;
			    	 while ((line2 = br2.readLine()) != null && !match) {
			    		 n_line2++;
			    		 if (!matches.containsKey(n_line2+"")) {				    		 
				    		 String cols2 [] = line2.split(csvSplitBy);
					    	 String name2 = cols2[col2];
					    	 boolean cond=false;
					    	 switch (invoker) {
					    	 	case "c_football":
					    	 					if (cols1[2].trim().equals(cols2[2].trim())) {
					    	 						cond=matching_words(name1, name2);
					    	 						if (!cond) {
					    	 							String n = cf_syn_map.get(name2.toLowerCase());
						    	 						if (name1.toLowerCase().equals(n))
						    	 							cond=true;
					    	 						}
						    	 				}
					    	 					break;		
					    	 	case "p_football":
					    	 					cond=matching_words_football(name1.replace("-"," ").replace(".", ""), name2.replace("-", " ").replace(".", ""));
					    	 					if (!cond) {
					    	 						String n = pf_syn_team_map.get(name1.toLowerCase());
					    	 						if (name2.toLowerCase().equals(n))
					    	 							cond=true;
					    	 					}
					    	 					break;
	    	 					case "p_tennis":
	    	 									cond=compair_names(name1, name2);
	    	 									break;
					    	 }
				    		 if (cond) {
				    			match = true;
				    			matches.put(n_line2+"", "");
				    		 	wr_same.append(name1+","+name2+"\n");
				    		 	int i;
				    		 	for (i=0; i<write_same.length-1; i++)
				    		 		append(wr_final, write_same[i], cols1, cols2, false);
				    		 	append(wr_final, write_same[i], cols1, cols2, true);
				    		 }
			    		 }
			    	 }
			    	 if (!match) {
			    		 int i;
		    		 	 for (i=0; i<write1.length-1; i++)
		    		 		append(wr_final, write1[i], cols1, null, false);
		    		 	 append(wr_final, write1[i], cols1, null, true);
			    	 }
			    	 br2.close();
			     }
			     if (write2!=null) {
				     br2 = new BufferedReader(new FileReader(file2));
			    	 String line_2 = br2.readLine();
			    	 int n_line2=1;
			    	 while ((line_2 = br2.readLine()) != null) {
			    		 n_line2++;
			    		 if (!matches.containsKey(n_line2+"")) {
			    			 String cols [] = line_2.split(csvSplitBy);
			    			 int i;
			    		 	 for (i=0; i<write2.length-1; i++)
			    		 		append(wr_final, write2[i], cols, null, false);
			    		 	 append(wr_final, write2[i], cols, null, true);
			    		 }
			    	 }
			     }
		    	 
		    } catch (FileNotFoundException e) {
		        e.printStackTrace();
		    } catch (IOException e) {
		        e.printStackTrace();
		    }
			
			try {
				if (br1 != null)
					br1.close();
				if (br2 != null)
					br2.close();
				if (wr_same != null)
					wr_same.close();
				if (wr_final != null)
					wr_final.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
	
	private void append (PrintWriter wr, String write, String [] cols1, String [] cols2, boolean end) {
		String s = "";
		if (write.substring(0, 1).equals("_"))
			s=write.substring(1);
		else {
			int i = Integer.parseInt(write.substring(1));
			if (write.substring(0,1).equals("1"))
				s=cols1[i];
			else
				s=cols2[i];
		}
		if (end)
			s+="\n";
		else
			s+=",";
		wr.append(s);
	}
	
	private boolean compair_names (String name1, String name2) {
		String words1 [] = name1.split(" ");
		boolean match=true;
		int i=words1.length-2;
		while(i>=0 && match) {
			String w=words1[i];
			match=name2.toLowerCase().contains(w.toLowerCase());
			i--;
		}
		i=0;
		int j=0;
		String w = words1[words1.length-1];
		String words2[] = name2.split(" ");
		while (i<w.length() && j<words2.length && match) {
			if (!w.substring(i,i+1).equals(words2[j].substring(0,1)))
				match=false;
			i+=2;
			j++;
		}
		return match;
	}
	
	public boolean matching_words (String name1, String name2) {
		int n = n_matching_words(name1, name2);
		return n==Integer.min(name1.split(" ").length, name2.split(" ").length);
	}
	
	public boolean matching_words (String name1, String name2, float perc) {
		int n = n_matching_words(name1, name2);
		int min=Integer.min(name1.split(" ").length, name2.split(" ").length);
		if (min<=2) 
			return n==min;
		else
			return n>=perc*min;
	}
	
	int n_matching_words (String name1, String name2) {
		String [] words1 = name1.split(" ");
		String [] words2 = name2.split(" ");
		int n_matches=0;
		for (int i=0; i<words1.length; i++) {
			 String w1 = words1[i];
			 for (int j=0; j<words2.length; j++) {
				 String w2 = words2[j];
				 if (w1.toUpperCase().equals(w2.toUpperCase()))
					 n_matches++;
			 }
		 }
		return n_matches;
	}
	
	
	public boolean matching_words_football (String name1, String name2) {
		int n = n_matching_words_football(name1, name2);
		return n==Integer.min(name1.split(" ").length, name2.split(" ").length);
	}
	
	int n_matching_words_football (String name1, String name2) {
		String [] words1 = name1.split(" ");
		String [] words2 = name2.split(" ");
		int n_matches=0;
		for (int i=0; i<words1.length; i++) {
			 String w1 = words1[i];
			 for (int j=0; j<words2.length; j++) {
				 String w2 = words2[j];
				 if (w1.toUpperCase().equals(w2.toUpperCase()))
					 n_matches++;
				 else {
					 String n = pf_syn_map.get(w1.toLowerCase());
					 if (w2.toLowerCase().equals(n))
						 n_matches++;
				 }
			 }
		}
		return n_matches;
	}
	
	protected void create_map(HashMap<String, String> map, String file) {
		try {
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = br.readLine();
			while ((line = br.readLine())!=null) {
				String [] cols = line.split(csvSplitBy);
				map.put(cols[0], cols[1]);
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
