# v0.1.0
* Initialize the project
* IRC API
  * Objects
    * User (represent a nick, id, whois)
    * Chan (a chan with users, name)
    * Client (a socket associated to an user)
    * Nick (availability, ...)
  * Actions
    * Handles one <-> one messages)
    * Handles one <-> many messages
    * Handles the connection and IO (connect, send, recv)
    * Masks (rights, ...)
    * Use Commands (Talk, Chan, User)
      * JOIN, PRIVSG, NOTICE, MODE, ...
      * OP, DEOP, BAN, ...
* Bot Framework
  * Set hooks and rules to trigger actions
  * Manage connected Users and Channels
* Robust testing and documentation
  * Specs on the complete API and protocol
  * Specs on the Framwork with basic and advanced use-cases
  * Real bot samples
