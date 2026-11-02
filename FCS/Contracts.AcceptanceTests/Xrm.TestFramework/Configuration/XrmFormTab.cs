// <copyright file="XrmPackageAttribute.cs" company="Ciber">
//     Company Copyright
// </copyright>

using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SFA.FCT.Xrm.TestFramework
{
    // Using statements for Assertions
    
    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPackageAttribute
    ///   Description:    Class for handing the Entity Metadata for a single Dynamics CRM attribute
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for handling Dynamics CRM Configuration of a single Dynamics CRM attribute
    /// </summary>
    public class XrmFormTab
    {
        #region Fields
        public string Name { get; set; }

        public string DisplayName { get; set; }

        private List<XrmPackageAttribute> fields;
        
        private List<XrmPackageAttribute> controls;

        public List<XrmPackageAttribute> Attributes
        {
            get
            {
                if (this.fields == null)
                {
                    this.fields = new List<XrmPackageAttribute>();
                }
                return this.fields;
            }
            set { this.fields = value; }
        }

        public List<XrmPackageAttribute> Controls
        {
            get
            {
                if (this.controls == null)
                {
                    this.controls = new List<XrmPackageAttribute>();
                }
                return this.controls;
            }
            set { this.controls = value; }
        }

        #endregion

        #region Constructors

        #endregion

        #region Methods

        public XrmPackageAttribute Field(string fieldName)
        {
            var fieldMatch = from f in this.fields where f.LogicalName == fieldName select f;

            if (fieldMatch.Count() == 0)
            {
                fieldMatch = from f in this.fields where f.displayName == fieldName select f;
            }

            Assert.IsTrue(fieldMatch.Count() > 0, "The Tab " + this.DisplayName + " does not include a control for the field: " + fieldName);
            return (XrmPackageAttribute)fieldMatch.First();
        }

        public XrmPackageAttribute HasSubGridWithView(string viewId)
        {
            var fieldMatch = from f in this.controls where f.LogicalName == viewId select f;

            if (fieldMatch.Count() == 0)
            {
                fieldMatch = from f in this.fields where f.displayName == viewId select f;
            }

            Assert.IsTrue(fieldMatch.Count() > 0, "The Tab " + this.DisplayName + " does not include a control for the field: " + viewId);
            return (XrmPackageAttribute)fieldMatch.First();
        }

        public XrmPackageAttribute HasQuickViewForm(string fieldName, string quickFormId)
        {
            var field = this.Field(fieldName);
          
            Assert.IsTrue(field.QuickFormId == quickFormId, "The Tab " + this.DisplayName + " does not include a quick view form for the field: " + quickFormId);
            return (XrmPackageAttribute)field;
        }

        #endregion
    }
}