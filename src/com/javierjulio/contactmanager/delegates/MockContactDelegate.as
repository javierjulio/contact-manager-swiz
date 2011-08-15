package com.javierjulio.contactmanager.delegates
{
	import com.javierjulio.contactmanager.models.ContactVO;
	import com.javierjulio.contactmanager.services.MockContactService;
	import com.javierjulio.utils.LogUtil;
	
	import mx.logging.ILogger;
	import mx.rpc.AsyncToken;
	
	public class MockContactDelegate
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Storage for the logger instance.
		 */
		private static const LOGGER:ILogger = LogUtil.getLogger(MockContactDelegate);
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Storage for the MockContactService used to save, remove or load contacts.
		 * 
		 * @default null
		 */
		protected var service:MockContactService;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function MockContactDelegate()
		{
			super();
			
			service = new MockContactService();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Loads a collection of contacts by name.
		 * 
		 * @param name The name to search by.
		 */
		public function loadByName(name:String=""):AsyncToken 
		{
			var token:AsyncToken = service.getContactsByName(name);
			token.method = "getContactsByName";
			
			return token;
		}
		
		/**
		 * Removes the given contact and adds the contact object on the token.
		 * 
		 * @param contact The contact object to be removed.
		 */
		public function remove(contact:ContactVO):AsyncToken 
		{
			LOGGER.info("Attempting to remove contact {0} named {1}.", 
				contact.id, contact.fullName);
			
			var token:AsyncToken = service.remove(contact);
			token.method = "remove";
			token.contact = contact;
			return token;
		}
		
		/**
		 * Saves the given contact and adds the contact object on the token.
		 * 
		 * @param contact The contact object to be saved.
		 */
		public function save(contact:ContactVO):AsyncToken 
		{
			LOGGER.info("Attempting to save contact {0} named {1}.", 
				contact.id, contact.fullName);
			
			var token:AsyncToken = service.save(contact);
			token.method = "save";
			token.contact = contact;
			return token;
		}
	}
}