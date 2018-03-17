package Classes;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class CompetitionsMaker extends Maker{
	private String competitions_esdb, competitions_fd, competitions_football, same_football;
	
	public CompetitionsMaker () {
		fd_div = cleaned_fd_div;
		competitions_esdb = etl_path + "created/competitions_esdb.csv";
		competitions_fd = etl_path + "divisions_fd_cleaned.csv";
		competitions_football = etl_path + "competitions_football.csv";
		same_football = etl_path +"competitions_same_football.csv";
		String [] write_same = {"10", "20", "11", "22", "13"};
		String [] write1 = {"10", "_", "11", "12", "13"};
		String [] write2 = {"_", "10", "11", "12", "_"};
		integrate(competitions_esdb, 1, competitions_fd, 1, competitions_football, "id_esdb,id_fd,name,country,country_id_esdb\n", same_football, write_same, write1, write2, "c_football");
	}
	public void integrate_HashMap(HashMap<String, HashMap<String, List<String>>> map_td, HashMap<String, HashMap<String, List<String>>> map_atpmt, String file) {
		try {
			PrintWriter wr = new PrintWriter(new File (file));
			wr.append("name,id_td,id_atpmt,location\n");
			for(String key_td : map_td.keySet()) {
				if (map_atpmt.containsKey(key_td)) {
					HashMap<String, List<String>> map_td2 = map_td.get(key_td);
					HashMap<String, List<String>> map_atpmt2 = map_atpmt.get(key_td);
					// analizzo i nomi di torneo, finisco quando ne trovo due uguali
					for(String key_td2 : map_td2.keySet()) {
						boolean same_competition = false;
						String key_td2_ok, key_atpmt2_ok = "", name_td_ok = "";
						List<String> names_td = map_td2.get(key_td2);
						for(String key_atpmt2 : map_atpmt2.keySet()) {
							List<String> names_atpmt = map_atpmt2.get(key_atpmt2);
							for(String name_td : names_td) {
								for(String name_atpmt : names_atpmt) {
									if(name_td.equalsIgnoreCase(name_atpmt) && matching_words(name_td, name_atpmt, 2/3)) {
										same_competition = true;
										name_td_ok = name_td;
										break;
									}
								}
								if(same_competition) {
									break;
								}
							}
							if(same_competition) {
								key_atpmt2_ok = key_atpmt2;
								map_atpmt2.remove(key_atpmt2);
								break;
							}
						}
						if(same_competition) {
							key_td2_ok = key_td2;
							wr.append(name_td_ok+","+key_td2_ok+","+key_atpmt2_ok+","+key_td+"\n");
						} else {
							wr.append(map_td2.get(key_td2).get(0)+","+key_td2+",,"+key_td+"\n");
						}
					}
					
				} else {
					HashMap<String, List<String>> map_td2 = map_td.get(key_td);
					for(String key_td2 : map_td2.keySet()) {
						wr.append(map_td2.get(key_td2).get(0)+","+key_td2+",,"+key_td+"\n");
					}
				}
				
			}
			for(String key_atpmt : map_atpmt.keySet()) {
				// scrivo su file tutte le mappe mancanti
				HashMap<String, List<String>> map_atpmt2 = map_atpmt.get(key_atpmt);
				for(String key_atpmt2 : map_atpmt2.keySet()) {
					wr.append(map_atpmt2.get(key_atpmt2).get(0)+",,"+key_atpmt2+","+key_atpmt+"\n");
				}
			}
			wr.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void createMap (String file1, HashMap <String, ArrayList<ArrayList <ArrayList<String>>>> map) {
		try {
			BufferedReader br1 = new BufferedReader(new FileReader(file1));
	        String line = br1.readLine();
	        HashMap <String, Integer> id_lookup = new HashMap <String, Integer> ();
	        while ((line=br1.readLine())!=null) {
	        	String [] cols = line.split(csvSplitBy);
	        	String id = cols[0];
	        	String location = cols[2];
	        	String name = cols[1];
	        	if (!map.containsKey(location)) {
		        	ArrayList <String> names = new ArrayList <String> ();
		        	ArrayList <String> ids = new ArrayList <String> ();
		        	ArrayList <ArrayList <String>> tournament = new ArrayList <ArrayList <String>> ();
		        	ArrayList <ArrayList <ArrayList <String>>> tournaments = new ArrayList <ArrayList <ArrayList <String>>> ();
	        		names.add(name);
	        		ids.add(id);
	        		tournament.add(ids);
	        		tournament.add(names);
	        		tournaments.add(tournament);
	        		map.put(location, tournaments);
	        		id_lookup.put(location+id,new Integer(0));
	        	} else {
	        		if (id_lookup.containsKey(location+id)) {
	        			if (!map.get(location).get(id_lookup.get(location+id)).get(1).contains(name)) {
	        				map.get(location).get(id_lookup.get(location+id)).get(1).add(name);
	        			}
	        		} else {
        	        	ArrayList <ArrayList <ArrayList <String>>> tournaments = map.get(location);
        				boolean equals = false;
        				for (int i=0; i<tournaments.size(); i++) {
        					//controllo se esiste un torneo nella stessa location con nome uguale
        					ArrayList <ArrayList <String>> tournament = tournaments.get(i);
        					ArrayList <String> names = tournament.get(1);
        					if (names.contains(name)) {
        						tournament.get(0).add(id);
        						id_lookup.put(location+id, i);
        						equals =true;
        						break;
        					}
        				}
        				if (!equals) {
        					for (int i=0; i<tournaments.size(); i++) {
        						ArrayList <ArrayList <String>> tournament = tournaments.get(i);
        						ArrayList <String> names = tournament.get(1);
    	        				for (String n : names) {
    	        					if (matching_words(name,n, 2/3)) {
    	        						tournament.get(0).add(id);
    	        						tournament.get(1).add(name);
		        						id_lookup.put(location+id, i);
		        						equals =true;
		        						break;
    	        					}
    	        				}
    	        				if (equals)
    	        					break;
        					}
        				}
        				if (!equals) {
	        	        	ArrayList <String> names = new ArrayList <String> ();
	        	        	ArrayList <String> ids = new ArrayList <String> ();
	    		        	ArrayList <ArrayList <String>> tournament = new ArrayList <ArrayList <String>> ();
	    		        	ArrayList <ArrayList <ArrayList <String>>> tournamentsNew = map.get(location);
        					names.add(name);
        					ids.add(id);
        					tournament.add(ids);
        					tournament.add(names);
        					tournamentsNew.add(tournament);
        	        		id_lookup.put(location+id,tournamentsNew.size()-1);     	
        				}
        			}
	        	}
	        		
	        }
	        br1.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void mergeMaps (HashMap <String, ArrayList<ArrayList <ArrayList<String>>>> map1, HashMap <String, ArrayList<ArrayList <ArrayList<String>>>> map2) {
		for (String x : map1.keySet()) {
			if (map2.containsKey(x))
				mergeTournaments(map1.get(x),map2.get(x));
			else {
				ArrayList<ArrayList<ArrayList<String>>> tournaments1 = map1.get(x);
				for(ArrayList<ArrayList<String>> tournament : tournaments1) {
					tournament.add(1, new ArrayList<String>());
				}
			}
		}
		for (String y : map2.keySet()){
			ArrayList<ArrayList<ArrayList<String>>> tournaments2 = map2.get(y);
			if(!tournaments2.isEmpty()) {
				if(map1.containsKey(y)) {
					for(ArrayList<ArrayList<String>> tournament : tournaments2) {
						ArrayList <ArrayList<String>> triple = new ArrayList <ArrayList<String>>();
						triple.add(new ArrayList<String>());
						triple.add(tournament.get(0));
						triple.add(tournament.get(1));
						map1.get(y).add(triple);
					}
				} else {
					for(ArrayList<ArrayList<String>> tournament : tournaments2) {
						tournament.add(0, new ArrayList<String>());
					}
					map1.put(y, tournaments2);
				}
			}
		}
		
	}
	
	public void mergeTournaments (ArrayList<ArrayList <ArrayList<String>>> a, ArrayList<ArrayList <ArrayList<String>>> b) {
		for (ArrayList <ArrayList<String>> x : a) {
			ArrayList <Integer> pos = new ArrayList <Integer> ();
			for (int i=0; i<b.size(); i++) {
				ArrayList <ArrayList<String>> y = b.get(i);
				ArrayList<String> names1 = x.get(1);
				ArrayList<String> names2 = y.get(1);
				if (compair(names1, names2)) {
					mergeArrays(names1, names2);
					x.add(1, y.get(0));
					pos.add(i);
					break;
				}
			}
			if(pos.isEmpty() && x.size() != 3) {
				x.add(1, new ArrayList<String>());
			} else {
				for (int p:pos) 
					b.remove(p);
			}
		}
	}
	
	public boolean compair (ArrayList<String> a, ArrayList<String> b) {
		for (String x:a) {
			for (String y:b) {
				if (matching_words(x,y, 2/3)) 
					return true;
			}
		}
		return false;
	}
	
	public void mergeArrays (ArrayList<String> a, ArrayList<String> b) {
		for (String x:b) {
			if (!a.contains(x))
				a.add(x);
		}
	}
}
