package com.javierjulio.utils
{
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * The LogUtil utility class is an all-static class with methods for working 
	 * with ILogger objects within Flex. You do not create instances of LogUtil; 
	 * instead you call methods such as the <code>LogUtil.getLogger()</code> 
	 * method.
	 */
	public class LogUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns a logger for the given class, using the fully qualified name of 
		 * the class as the name of the logger.
		 * 
		 * @param clazz The Class.
		 */
		public static function getLogger(clazz:Class):ILogger 
		{
			var path:String = getQualifiedClassName(clazz);
			path = path.replace("::", ".");
			
			return Log.getLogger(path);
		}
	}
}