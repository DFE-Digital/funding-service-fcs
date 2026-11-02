// <copyright file="XrmXmlHelpers.cs" company="Ciber">
//     Company Copyright
// </copyright>

namespace SFA.FCT.Xrm.TestFramework
{
    using System;

    /// <summary>
    /// Static XrmHelpers Class - used for common methods for parsing Xml
    /// </summary>
    public static class ExtensionMethods
    {
        public static DateTime TrimMilliseconds(this DateTime dt)
        {
            return new DateTime(dt.Year, dt.Month, dt.Day, dt.Hour, dt.Minute, dt.Second, dt.Kind);
        }
    }
}