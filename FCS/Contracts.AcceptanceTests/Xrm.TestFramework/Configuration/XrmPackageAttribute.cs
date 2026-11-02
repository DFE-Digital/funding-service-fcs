// <copyright file="XrmPackageAttribute.cs" company="Ciber">
//     Company Copyright
// </copyright>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

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
    [DebuggerDisplay("{displayName}")]
    public class XrmPackageAttribute
    {
        #region Fields
        /// <summary>
        /// Xml Document path for holding Optionset Data
        /// </summary>
        private string optionSetDirectory;

        /// <summary>
        /// List of OptionSet values
        /// </summary>
        public Dictionary<int, string> OptionSetList { get; set; }

        public Dictionary<string, int> OptionSetValues { get; set; }

        /// <summary>
        /// bool value for use with <see cref="XrmPackageForm"/> class 
        /// </summary>
        private bool formEnabled;

        /// <summary>
        /// Lookup parameter for use with the <see cref="XrmPackageForm"/> class
        /// </summary>
        private XrmPackageLookupParameter lookupParameter;

        /// <summary>
        /// Gets the display name of the attribute
        /// </summary>
        internal string displayName;

        /// <summary>
        /// 
        /// </summary>
        internal bool primaryKey;

        /// <summary>
        /// Gets the data type of the attribute
        /// </summary>
        internal string dataType;

        /// <summary>
        /// Gets the length of the attribute (Text fields only)
        /// </summary>
        protected int length;

        /// <summary>
        /// Gets the minimum value of the attribute (numeric fields only)
        /// </summary>
        protected decimal maxValue;

        /// <summary>
        /// Gets the minimum value of the attribute (numeric fields only)
        /// </summary>
        protected decimal minValue;

        /// <summary>
        /// Gets the required level of the attribute
        /// </summary>
        protected string requiredLevel;

        /// <summary>
        /// Gets a value corresponding to whether the field is valid for advanced find
        /// </summary>
        protected bool validForAdvancedFind;

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageAttribute"/> class
        /// </summary>
        public XrmPackageAttribute()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageAttribute" /> class.
        /// </summary>
        /// <param name="xmlNode">XML Node corresponding to the Attribute Element</param>
        /// <param name="optionSetPathParam">Path to the optionset values</param>
        /// <param name="lookupXml">Xml Node corresponding to the lookup parameters</param>
        public XrmPackageAttribute(XmlNode xmlNode, string optionSetPathParam)
        {
            this.optionSetDirectory = optionSetPathParam;

            XmlNode newNode = xmlNode.SelectSingleNode("LogicalName");
            this.LogicalName = xmlNode.SelectSingleNode("LogicalName").InnerText;

            if (xmlNode.SelectSingleNode(@"displaynames/displayname[@languagecode=""1033""]") != null)
            {
                this.displayName = xmlNode.SelectSingleNode(@"displaynames/displayname[@languagecode=""1033""]").Attributes["description"].Value;
            }

            this.dataType = xmlNode.SelectSingleNode("Type").InnerText;

            // Check if Display Mask exists - for the Valid for Advanced 
            if (xmlNode.SelectSingleNode("DisplayMask") != null)
            {
                string displayMask = xmlNode.SelectSingleNode("DisplayMask").InnerText;

                this.validForAdvancedFind = displayMask.Contains("ValidForAdvancedFind");
                this.primaryKey = displayMask.Contains("PrimaryName");
            }

            this.requiredLevel = xmlNode.SelectSingleNode("RequiredLevel").InnerText;

            // Check attribute types and update accordingly
            if (this.dataType == XrmDataType.WholeNumber)
            {
                // Check if Min/Max values are set - some system fields have these set to null e.g. trackingtokeniddigits
                if (xmlNode.SelectSingleNode("MinValue") != null
                    && (xmlNode.SelectSingleNode("MaxValue") != null))
                {
                    this.minValue = int.Parse(xmlNode.SelectSingleNode("MinValue").InnerText);
                    this.maxValue = int.Parse(xmlNode.SelectSingleNode("MaxValue").InnerText);
                }
            }
            else if (this.dataType == XrmDataType.Decimal)
            {
                // Check if Min/Max values are set - some system fields have these set to null e.g. trackingtokeniddigits
                if (xmlNode.SelectSingleNode("MinValue") != null
                    && (xmlNode.SelectSingleNode("MaxValue") != null))
                {
                    this.minValue = decimal.Parse(xmlNode.SelectSingleNode("MinValue").InnerText, System.Globalization.NumberStyles.Any);
                    this.maxValue = decimal.Parse(xmlNode.SelectSingleNode("MaxValue").InnerText, System.Globalization.NumberStyles.Any);
                }
            }
            else if (this.dataType == XrmDataType.Text)
            {
                this.length = int.Parse(xmlNode.SelectSingleNode("MaxLength").InnerText);
            }
            else if (this.dataType == XrmDataType.OptionSet)
            {
                Dictionary<int, string> optionSetList = new Dictionary<int, string>();
                var optionSetNode = xmlNode.SelectSingleNode("OptionSetName");

                if (optionSetNode != null)
                {
                    string optionSetName = optionSetNode.InnerText.ToLowerInvariant();

                    string optionSetPath = (from o in System.IO.Directory.GetFiles(this.optionSetDirectory)
                                            where System.IO.Path.GetFileNameWithoutExtension(o) == optionSetName
                                            select System.IO.Path.GetFileName(o)).FirstOrDefault();

                    // Open document
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.Load(this.optionSetDirectory + "//" + optionSetPath);

                    try
                    {
                        foreach (XmlNode x in xmlDocument.SelectNodes("//optionset/options/option"))
                        {
                            int key = int.Parse(x.Attributes["value"].Value);
                            string value = x.SelectSingleNode(@"./labels/label[@languagecode=""1033""]").Attributes["description"].Value;
                            optionSetList.Add(key, value);
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
                    }
                }
                else
                {
                    optionSetNode = xmlNode.SelectSingleNode("optionset");

                    try
                    {
                        foreach (XmlNode x in optionSetNode.SelectNodes("options/option"))
                        {
                            int key = int.Parse(x.Attributes["value"].Value);
                            string value = x.SelectSingleNode(@"./labels/label[@languagecode=""1033""]").Attributes["description"].Value;
                            optionSetList.Add(key, value);
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
                    }
                }
                this.OptionSetList = optionSetList;

            }
            else if (this.dataType == XrmDataType.State)
            {
                Dictionary<int, string> optionSetList = new Dictionary<int, string>();

                try
                {
                    foreach (XmlNode x in xmlNode.SelectNodes("optionset/states/state"))
                    {
                        int key = int.Parse(x.Attributes["value"].Value);
                        string value = x.Attributes["invariantname"].Value;
                        optionSetList.Add(key, value);
                    }

                    this.OptionSetList = optionSetList;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
                }
            }
            else if (this.dataType == XrmDataType.Status)
            {
                Dictionary<int, string> optionSetList = new Dictionary<int, string>();

                try
                {
                    foreach (XmlNode x in xmlNode.SelectNodes("optionset/statuses/status"))
                    {
                        int key = int.Parse(x.Attributes["value"].Value);
                        string value = x.SelectSingleNode(@"./labels/label[@languagecode=""1033""]").Attributes["description"].Value;
                        optionSetList.Add(key, value);
                    }

                    this.OptionSetList = optionSetList;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
                }
            }
            else if (this.dataType == XrmDataType.TwoOptions)
            {
                Dictionary<int, string> optionSetList = new Dictionary<int, string>();

                try
                {
                    foreach (XmlNode x in xmlNode.SelectNodes("optionset/options/option"))
                    {
                        int key = int.Parse(x.Attributes["value"].Value);
                        string value = x.SelectSingleNode(@"./labels/label[@languagecode=""1033""]").Attributes["description"].Value;
                        optionSetList.Add(key, value);
                    }

                    this.OptionSetList = optionSetList;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
                }
            }

            if (this.OptionSetList != null)
            {
                this.OptionSetValues = new Dictionary<string, int>();
                foreach (var kv in this.OptionSetList)
                {
                    this.OptionSetValues.Add(kv.Value, kv.Key);
                }
            }
        }

        /// <summary>
        /// Initializes a new instance of the XrmPackageAttribute class - for use with XrmPackageForm
        /// </summary>
        /// <param name="fieldName">Logical Name of the attribute</param>
        /// <param name="formEnabled">bool value indicating whether it is enabled on the form by default</param>
        /// <param name="displayName">Display Name of the control</param>
        public XrmPackageAttribute(string fieldName, bool formEnabled, XmlNode lookupXml, string displayName)
        {
            this.LogicalName = fieldName;
            this.formEnabled = formEnabled;
            this.displayName = displayName;
            if (lookupXml != null)
            {
                this.lookupParameter = new XrmPackageLookupParameter(lookupXml, this.LogicalName);
            }
        }

        /// <summary>
        /// Initializes a new instance of the XrmPackageAttribute class - for use with XrmPackageForm
        /// </summary>
        /// <param name="fieldName">Logical Name of the attribute</param>
        /// <param name="formEnabled">bool value indicating whether it is enabled on the form by default</param>
        /// <param name="displayName">Display Name of the control</param>
        public XrmPackageAttribute(string fieldName, bool formEnabled, XmlNode lookupXml, string displayName, string quickFormId)
        {
            this.LogicalName = fieldName;
            this.formEnabled = formEnabled;
            this.displayName = displayName;
            this.QuickFormId = quickFormId;
            if (lookupXml != null)
            {
                this.lookupParameter = new XrmPackageLookupParameter(lookupXml, this.LogicalName);
            }
        }

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets a value corresponding to the logical name of the attribute
        /// </summary>
        public string LogicalName { get; set; }

        /// <summary>
        /// Get quick View Form Id
        /// </summary>
        public string QuickFormId;

        #endregion

        #region Methods
        /// <summary>
        /// Verifies the CRM OptionSet has a value matching the parameters. Will fail assertion if either the value is not in the optionset or the label does not match the parameter
        /// </summary>
        /// <param name="optionSetValue">The value for the optionset item</param>
        /// <param name="optionSetLabel">The label for the associated optionset value</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute WithOption(int optionSetValue, string optionSetLabel)
        {
            var optionSetPairs = from o in this.OptionSetList where o.Key == optionSetValue select o;

            if (optionSetPairs.Any())
            {
                Assert.IsTrue(optionSetPairs.First().Value == optionSetLabel, "The Option Set label for value " + optionSetValue + " is \"" + optionSetPairs.First().Value + "\"; not \"" + optionSetLabel + "\"");
            }
            else
            {
                Assert.Fail("The OptionSet value: " + optionSetValue + " is not in the Options for the " + this.LogicalName + " attribute");
            }

            return this;
        }

        /// <summary>
        /// Verifies the enabled property of the field on the XrmForm matches the boolean in the parameter. Will fail assertion if the disabled property does not match the boolean value
        /// </summary>
        /// <param name="isDisabled">A boolean value for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute IsDisabled(bool isDisabled)
        {
            Assert.IsTrue(this.formEnabled == !isDisabled, "The form field " + this.LogicalName + " has disabled status " + (!this.formEnabled) + "; not " + isDisabled);

            return this;
        }

        /// <summary>
        /// Verifies the attribute has the correct data type. Assertion will fail if this does not match parameter
        /// </summary>
        /// <param name="dataType">The data type for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute HasType(string dataType)
        {
            Assert.IsTrue(this.dataType == dataType, "The data type of the " + this.LogicalName + " attribute is " + this.dataType + "; not " + dataType);
            return this;
        }

        /// <summary>
        /// Verifies the attribute has the correct length. Assertion will fail if this does not match parameter
        /// </summary>
        /// <param name="maxLength">The maximum length for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute OfLength(int maxLength)
        {
            Assert.IsTrue(this.length == maxLength, "The length of the attribute " + this.length + "; not " + maxLength);
            return this;
        }

        /// <summary>
        /// Verifies the attribute has the correct max value. Assertion will fail if this does not match parameter
        /// </summary>
        /// <param name="maxValue">The max value for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute WithMaxValue(int maxValue)
        {
            Assert.IsTrue(this.maxValue == maxValue, "The max length of the attribute " + this.LogicalName + " is " + this.maxValue + "; not " + maxValue);
            return this;
        }

        /// <summary>
        /// Verifies the attribute has the correct min value. Assertion will fail if this does not match parameter.
        /// </summary>
        /// <param name="minValue">The min value for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute WithMinValue(int minValue)
        {
            Assert.IsTrue(this.minValue == minValue, "The min length of the attribute " + this.LogicalName + " is " + this.maxValue + "; not " + minValue);
            return this;
        }

        /// <summary>
        /// Verifies the attribute has the correct display name. Assertion will fail if this does not match parameter.
        /// </summary>
        /// <param name="displayName">The display name for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute HasDisplayName(string displayName)
        {
            if (string.IsNullOrWhiteSpace(this.displayName))
            {
                Assert.Fail("There is no Display Name defined for the " + this.LogicalName + "attribute");
            }

            Assert.IsTrue(this.displayName == displayName, "The Display Name of the attribute " + this.LogicalName + " is " + this.displayName + "; not " + displayName);
            return this;
        }

        /// <summary>
        /// Verifies the attribute is valid for advanced find. Assertion will fail if this is not true.
        /// </summary>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute IsValidForAdvancedFind()
        {
            Assert.IsTrue(this.validForAdvancedFind, "The attribute " + this.LogicalName + " is not valid for Advanced Find");
            return this;
        }

        /// <summary>
        /// Verifies the attribute has the correct requirement level. Assertion will fail if this is not true
        /// </summary>
        /// <param name="requirementLevel">The requirement level for verification</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageAttribute HasRequirementLevel(string requirementLevel)
        {
            if (string.IsNullOrWhiteSpace(this.requiredLevel))
            {
                Assert.Fail("This attribute " + this.LogicalName + " has no Requirement Level");
            }

            Assert.IsTrue(this.requiredLevel == requirementLevel, "The attribute " + this.LogicalName + " has a requirement level of: " + this.requiredLevel + "; not " + requirementLevel);
            return this;
        }

        /// <summary>
        /// Returns the lookup parameters for the requested Form Attribute
        /// </summary>
        /// <returns></returns>
        public XrmPackageLookupParameter Lookup()
        {
            Assert.IsTrue(this.lookupParameter != null, "The field " + this.LogicalName + " does not contain a lookup parameter on the form requested");

            return this.lookupParameter;
        }

        #endregion
    }
}