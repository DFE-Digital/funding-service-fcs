// <copyright file="XrmPackageLookupParameter.cs" company="Ciber">
//     Company Copyright
// </copyright>

using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SFA.FCT.Xrm.TestFramework
{
    // Using statements for Assertions
    
    /// <summary>
    /// Class used to define a set of parameters for use with a Filtered Lookup on a CRM Form
    /// </summary>
    public class XrmPackageLookupParameter
    {
        #region fields

        /// <summary>
        /// Specifies the logical name for the field lookup
        /// </summary>
        private string fieldLogicalName;
        
        /// <summary>
        /// Specifies whether a lookup field can auto-resolve
        /// </summary>
        private bool autoResolve;

        /// <summary>
        /// Specifies whether a lookup field can use the Most Recently Used Items list
        /// </summary>
        private bool disableMru;

        /// <summary>
        /// Specifies whether a lookup field can use the QuickFind view
        /// </summary>
        private bool disableQuickFind;

        /// <summary>
        /// Specifies whether a lookup field can use the View Picker
        /// </summary>
        private bool disableViewPicker;

        /// <summary>
        /// Specifies the attribute that will be passed up for the filter
        /// </summary>
        private string dependantAttributeName;

        /// <summary>
        /// Specifies whether the user is able to turn the filter off for the lookup
        /// </summary>
        private bool allowFilterOff;

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageLookupParameter"/> Class
        /// </summary>
        /// <param name="lookupXml">The XML representing the lookup parameter</param>
        public XrmPackageLookupParameter(XmlNode lookupXml, string logicalFieldName)
        {
            if (lookupXml != null)
            {
                this.fieldLogicalName = logicalFieldName;
                this.autoResolve = XrmXmlHelpers.GetBoolValueFromEntityNode(lookupXml, "./AutoResolve");
                this.disableMru = XrmXmlHelpers.GetBoolValueFromEntityNode(lookupXml, "./DisableMru");
                this.disableQuickFind = XrmXmlHelpers.GetBoolValueFromEntityNode(lookupXml, "./DisableQuickFind");
                this.disableViewPicker = XrmXmlHelpers.GetBoolValueFromEntityNode(lookupXml, "./DisableViewPicker");

                string dependantAttributeNameString = XrmXmlHelpers.GetStringValueFromXmlNode(lookupXml, "./DependentAttributeName");
                string[] attributeArray = dependantAttributeNameString.Split('.');
                this.dependantAttributeName = attributeArray[attributeArray.Length-1];
                this.allowFilterOff = XrmXmlHelpers.GetBoolValueFromEntityNode(lookupXml, "./AllowFilterOff");
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Validates that the lookup has the correct filter attribute. Assertion will fail if the attribute does not match the parameter
        /// </summary>
        /// <param name="filterAttributeString">The logical name of the filtering attribute passed to the lookup</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageLookupParameter FilterAttribute(string filterAttributeString)
        {
            Assert.IsTrue(this.dependantAttributeName == filterAttributeString, "The form field " + this.fieldLogicalName + " has a filter on the field \"" + this.dependantAttributeName + "\"; not \"" + filterAttributeString + "\"");

            return this;
        }

        /// <summary>
        /// Verifies that the lookup has the correct auto-resolution state
        /// </summary>
        /// <param name="isAutoResolve">bool to check for auto-resolution state</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageLookupParameter AutoResolve(bool isAutoResolve)
        {
            Assert.IsTrue(this.autoResolve == isAutoResolve, "The form field " + this.fieldLogicalName + " has disable auto-resolution status: " + this.autoResolve + "; not " + isAutoResolve);

            return this;
        }

        /// <summary>
        /// Verifies that the lookup has the correct auto-resolution state
        /// </summary>
        /// <param name="isAutoResolve">bool to check for auto-resolution state</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageLookupParameter DisableMRU(bool isDisableMru)
        {
            Assert.IsTrue(this.disableMru == isDisableMru, "The form field " + this.fieldLogicalName + " has Disable Most Recently Used status: " + this.disableMru + "; not " + isDisableMru);

            return this;
        }

        /// <summary>
        /// Verifies that the lookup has the correct quick find state
        /// </summary>
        /// <param name="isAutoResolve">bool to check for quick find state</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageLookupParameter DisableQuickFind(bool isDisableQuickFind)
        {
            Assert.IsTrue(this.disableQuickFind == isDisableQuickFind, "The form field " + this.fieldLogicalName + " has Disable Quick Find status: " + this.disableQuickFind + "; not " + isDisableQuickFind);

            return this;
        }

        /// <summary>
        /// Verifies that the lookup has the correct view picker state
        /// </summary>
        /// <param name="isAutoResolve">bool to check for view picker state</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageLookupParameter DisableViewPicker(bool isDisableViewPicker)
        {
            Assert.IsTrue(this.disableViewPicker == isDisableViewPicker, "The form field " + this.fieldLogicalName + " has Disable View Picker status: " + this.disableViewPicker + "; not " + isDisableViewPicker);

            return this;
        }

        /// <summary>
        /// Verifies that the lookup has the filter state
        /// </summary>
        /// <param name="isAutoResolve">bool to check for filter state</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageLookupParameter AllowFilterOff(bool isAllowFilterOff)
        {
            Assert.IsTrue(this.allowFilterOff == isAllowFilterOff, "The form field " + this.fieldLogicalName + " has Disable View Picker status: " + this.allowFilterOff + "; not " + isAllowFilterOff);

            return this;
        }

        #endregion

    }
}
