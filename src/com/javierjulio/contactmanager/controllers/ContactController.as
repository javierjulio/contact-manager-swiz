package com.javierjulio.contactmanager.controllers
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import com.javierjulio.contactmanager.delegates.MockContactDelegate;
	import com.javierjulio.contactmanager.enum.DepartmentEnum;
	import com.javierjulio.contactmanager.enum.IEnum;
	import com.javierjulio.contactmanager.events.ContactEvent;
	import com.javierjulio.contactmanager.events.SearchEvent;
	import com.javierjulio.contactmanager.models.ContactModel;
	import com.javierjulio.contactmanager.models.ContactVO;
	import org.swizframework.controller.AbstractController;
	
	public class ContactController extends AbstractController
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.controller.ContactController");
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ContactController()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var contactDelegate:MockContactDelegate;
		
		[Inject]
		public var contactModel:ContactModel;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		[EventHandler("ContactEvent.DELETE", properties="contact")]
		/**
		 * Deletes the given contact from the service.
		 * 
		 * @param contact The contact object.
		 */
		public function deleteContact(contact:ContactVO):void 
		{
			executeServiceCall(contactDelegate.remove(contact), resultHandler, faultHandler);
		}
		
		[EventHandler("ContactEvent.FILTER", properties="departmentFilter")]
		/**
		 * Filters a collection of contacts based on the department filter given. 
		 * If no filter is provided the default or currently selected filter is 
		 * used.
		 * 
		 * @param departmentFilter The DepartmentEnum object.
		 */
		public function filterContacts(departmentFilter:IEnum=null):void 
		{
			departmentFilter = (departmentFilter == null) 
								? contactModel.selectedFilter 
								: departmentFilter;
			
			contactModel.filterBy(departmentFilter);
		}
		
		[EventHandler("SearchEvent.SEARCH", properties="entry")]
		/**
		 * Loads a collection of contacts based on the search entry given. If no 
		 * entry is provided then the last entry is used.
		 * 
		 * @param entry The entry 
		 */
		public function loadContacts(entry:String=null):void 
		{
			entry = (!entry) ? contactModel.lastNameLookUp : entry;
			
			contactModel.lastNameLookUp = entry;
			
			executeServiceCall(contactDelegate.loadByName(entry), resultHandler, faultHandler);
		}
		
		[EventHandler("ContactEvent.SAVE", properties="contact")]
		/**
		 * When the user requests to save a contact we have the ContactProxy save 
		 * it with the service.
		 * 
		 * @param contact The contact object.
		 */
		public function saveContact(contact:ContactVO):void 
		{
			executeServiceCall(contactDelegate.save(contact), resultHandler, faultHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When a service call has failed we alert the error message to the user. 
		 * Ideally here you would dispatch a specific event indicating failure.
		 * 
		 * @param event The FaultEvent object.
		 */
		public function faultHandler(event:FaultEvent):void 
		{
			var method:String = event.token.method;
			
			LOGGER.error("An error occurred processing the method request '{0}'. {1}", 
				method, event.fault.toString());
		}
		
		/**
		 * When the service call was successful we handle the appropriate method 
		 * and take whatever necessary action for that method.
		 * 
		 * @param event The ResultEvent object.
		 */
		public function resultHandler(event:ResultEvent):void 
		{
			var method:String = event.token.method;
			var contact:ContactVO;
			
			switch (method) 
			{
				case "getContactsByName":
					// proxy has a public data property with traditional 
					// setter and getter methods but we want to expose the 
					// contacts collection as read only so by setting data, 
					// the next time the contacts property is called it'll 
					// be retrieved
					contactModel.contacts = ArrayCollection(event.result);
					
					LOGGER.info("{0} contacts loaded successfully.", contactModel.contacts.length);
					
					filterContacts();
					
					_swiz.dispatcher.dispatchEvent(new ContactEvent(ContactEvent.LOADED));
					break;
				
				case "remove":
					contact = ContactVO(event.token.contact);
					
					LOGGER.info("The contact named {0} has been removed.", contact.fullName);
					
					// removal was successful, since we are given the contact 
					// object pass it along anyway if it needs to be used, 
					// for example, indicating through a message the name 
					// of the contact that was removed successfully
					_swiz.dispatcher.dispatchEvent(new ContactEvent(ContactEvent.REMOVED, contact));
					break;
				
				case "save":
					var originalContact:ContactVO = event.token.contact;
					
					contact = ContactVO(event.result);
					
					// when saving a new contact, the view will create its 
					// own contact object instance, but the service returns 
					// its own instance, so we need to make sure to keep 
					// ours updated with the new id
					originalContact.id = contact.id;
					
					LOGGER.info("The contact named {0} with an id of {1} has been saved.", 
						contact.fullName, contact.id);
					
					// save was successful, since we are given the contact 
					// object pass it along anyway if it needs to be used, 
					// for example, indicating through a message the name 
					// of the contact that was saved successfully
					_swiz.dispatcher.dispatchEvent(new ContactEvent(ContactEvent.SAVED, contact));
					break;
				
			}
		}
	}
}