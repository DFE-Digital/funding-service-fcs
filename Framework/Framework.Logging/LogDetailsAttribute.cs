namespace SFA.FCT.Framework.Logging
{
    using System;

    [AttributeUsage(AttributeTargets.Class)]
    public class LogDetailsAttribute : Attribute
    {
    }

    [AttributeUsage(AttributeTargets.Property)]
    public class LogDetailAttribute : Attribute
    {
        public LogDetailAttribute(string propertyName = null)
        {
            if (propertyName != null)
            {
                LogPropertyName = propertyName;
            }
        }

        public string LogPropertyName { get; private set; }
    }
}