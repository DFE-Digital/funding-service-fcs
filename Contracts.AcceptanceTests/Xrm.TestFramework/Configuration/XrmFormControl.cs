// <copyright file="XrmPackageFormControl.cs" company="Ciber">
//     Company Copyright
// </copyright>

namespace SFA.FCT.Xrm.TestFramework
{
    // Using statements for Assertions

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmFormControl
    ///   Description:    Class for handing the Entity Metadata for a single Dynamics CRM attribute
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for handling Dynamics CRM Configuration of a single Dynamics CRM attribute
    /// </summary>
    public class XrmFormControl
    {
        #region Fields

        public string Name { get; set; }

        public string DisplayName { get; set; }

        public string ViewId { get; set; }

        #endregion
    }
}