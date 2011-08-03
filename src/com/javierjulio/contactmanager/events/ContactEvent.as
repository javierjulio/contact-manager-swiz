package com.javierjulio.contactmanager.events
{
	import flash.events.Event;
	
	import com.javierjulio.contactmanager.enum.IEnum;
	import com.javierjulio.contactmanager.models.ContactVO;
	
	public class ContactEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const ADD:String = "addContact";
		public static const DELETE:String = "deleteContact";
		public static const EDIT:String = "editContact";
		public static const FILTER:String = "filterContacts";
		public static const LOADED:String = "contactsLoaded";
		public static const OPEN_EDITOR:String = "openEditor";
		public static const REMOVED:String = "contactRemoved";
		public static const SAVE:String = "saveContact";
		public static const SAVED:String = "contactSaved";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ContactEvent(type:String, 
									contact:ContactVO=null, 
									departmentFilter:IEnum=null, 
									showProgress:Boolean=false, 
									bubbles:Boolean=true, 
									cancelable:Boolean=true) 
   		{
			super(type, bubbles, cancelable);
			
   			this.contact = contact;
			this.departmentFilter = departmentFilter;
			this.showProgress = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  contact
		//----------------------------------
		
		/**
		 * The contact object.
		 * 
		 * @default null
		 */
		public var contact:ContactVO;
		
		//----------------------------------
		//  departmentFilter
		//----------------------------------
		
		/**
		 * The department filter object.
		 * 
		 * @default null
		 */
		public var departmentFilter:IEnum;
		
		//----------------------------------
		//  showProgress
		//----------------------------------
		
		// FIXME: need to find a consistent way to set progress on Main App window
		
		/**
		 * A flag that determines whether to show a progress indicator on an 
		 * asynchronous action like loading contacts.
		 * 
		 * @default false
		 */
		public var showProgress:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritdoc
		 */
		override public function clone():Event 
		{
			return new ContactEvent(type, contact, departmentFilter, showProgress, bubbles, cancelable);
		}
		
		/**
		 * @inheritdoc
		 */
		override public function toString():String 
		{
			return '[ContactEvent type="' + type + '" contact="' + contact 
				+ '" bubbles="' + bubbles + '" cancelable="' + cancelable + '"]';
		}
	}
}