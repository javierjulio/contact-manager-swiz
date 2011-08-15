package com.javierjulio.contactmanager.models
{
	import com.javierjulio.contactmanager.enum.DepartmentEnum;
	import com.javierjulio.contactmanager.enum.IEnum;
	import com.javierjulio.utils.LogUtil;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class ContactModel
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
		private static const LOGGER:ILogger = LogUtil.getLogger(ContactModel);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ContactModel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable]
		public var contacts:ArrayCollection;
		
		/**
		 * Storage for the last name look up so the collection of contacts can be 
		 * reloaded from the service.
		 * 
		 * @default ""
		 */
		public var lastNameLookUp:String = "";
		
		//----------------------------------
		//  selectedFilter
		//----------------------------------
		
		/**
		 * @private
		 * Storage for the selectedFilter property.
		 */
		private var _selectedFilter:IEnum = DepartmentEnum.defaultEnum();
		
		/**
		 * The current selected filter.
		 * 
		 * @default DepartmentEnum.defaultEnum()
		 */
		public function get selectedFilter():IEnum 
		{
			return _selectedFilter as DepartmentEnum;
		}
		
		/**
		 * @private
		 */
		public function set selectedFilter(value:IEnum):void 
		{
			// value can't be null, use default if data isn't already set
			if (!value && !_selectedFilter) 
				value = DepartmentEnum.defaultEnum();
			
			// if the values are the same cancel out, if the value provided is 
			// null we are happy keeping the current selection
			if (_selectedFilter == value || !value) 
				return;
			
			_selectedFilter = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Filters the contacts collection based on the DepartmentEnum given.
		 * 
		 * @param filter The DepartmentEnum instance to filter by.
		 */
		public function filterBy(filter:IEnum):void 
		{
			if (!contacts) 
				return;
			
			// update our tracker with the new selected filter
			selectedFilter = filter;
			
			// INFO: this is a simple example but can easily be expanded on to 
			// include more filters and even custom sorts.
			
			contacts.filterFunction = departmentFilter;
			contacts.refresh();
			
			LOGGER.info("Filter completed and {0} contacts in collection.", contacts.length);
		}
		
		/**
		 * @private
		 */
		private function departmentFilter(contact:ContactVO):Boolean 
		{
			if (selectedFilter == DepartmentEnum.ALL) 
				return true;
			
			return (contact.department == selectedFilter.label);
		}
	}
}