This folder contains the code for the following strategies used in simulation:

+ Like Strategy: Once a peer decides to like a document, this strategy would connect that peer to that document through a directed link, called connect-link.

+ Follow Strategy: Once a peer decides to follow another peer, this strategy would connect that peer to that target peer throug ha directed links, called, connect-link.

+ Payoff Stategy: It calculates a peer payoff in each run, The payoff for producers and consumers are calculated differently. 
  * Payoff of producer: The number of times that documents that match with the peer's taste are placed in the topK of other peers, including other producers, since the last run of that peer 
  * Payoff of Consumer: The number of documents in topK that matches the peer's taste *  reward value  - The number of documents that does matches with the peer's taste * punishment value 


+ Rank Srategy: Thses are the different document filtering strategys that are studied during the experiment. We use the "with memory" version of these strategies, which keeps record of topK documents in each run, and does not repeat them in the next runs of that peers. The main rakning strategies in our experiments are: 

     * Random 
     * Peer-like-similarity
     * Peer-follow-similarity
     * Peer-distance
     * Document-popularity
     * Follow-popularity 





