// <copyright file="XrmWebAttribute.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace Ciber.Xrm.Tests.MetaData
{
    // Using statements for Assertions
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    // Using statements for Dynamics CRM Namespaces
    using Microsoft.Xrm.Sdk.Metadata;
    using System;
    using System.Linq;

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmWebAttribute
    ///   Description:    Class for handing the Entity Metadata for a single Dynamics CRM attribute
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for handling Dynamics CRM Configuration of a single Dynamics CRM attribute
    /// </summary>
    public class XrmWebAttribute
    {
        #region Fields
        /// <summary>
        /// Attribute MetaData extracted from Dynamics CRM Solution
        /// </summary>
        private AttributeMetadata attributeMetaData;

        /// <summary>
        /// Picklist Attribute Metadata extracted from the Dynamics CRM Solution - will only be set for OptionSet Attributes
        /// </summary>
        private PicklistAttributeMetadata optionSetMetaData;

        /// <summary>
        /// Boolean Attribute Metadata extracted from the Dynamics CRM Solution - will only be set for Boolean (Two Options) Attributes
        /// </summary>
        private BooleanAttributeMetadata booleanMetaData;

        #endregion

        #region Constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="XrmWebAttribute" /> class.
        /// </summary>
        /// <param name="attributeMetaData">Attribute Metadata from the Dynamics CRM Web Service</param>
        public XrmWebAttribute(AttributeMetadata attributeMetaData)
        {
            // Update Attribute with basic data values
            this.attributeMetaData = attributeMetaData;
            this.LogicalName = attributeMetaData.LogicalName;
            this.displayName = (from l in attributeMetaData.DisplayName.LocalizedLabels select l.Label).FirstOrDefault();
            this.dataType = XrmDataType.Convert(attributeMetaData.AttributeType.ToString());
            this.validForAdvancedFind = attributeMetaData.IsValidForAdvancedFind.Value;
            switch (attributeMetaData.RequiredLevel.Value)
            {
                case AttributeRequiredLevel.None:
                    this.requiredLevel = XrmRequirementLevel.None;
                    break;
                case AttributeRequiredLevel.Recommended:
                    this.requiredLevel = XrmRequirementLevel.BusinessRecommended;
                    break;
                case AttributeRequiredLevel.ApplicationRequired:
                    this.requiredLevel = XrmRequirementLevel.BusinessRequired;
                    break;
                case AttributeRequiredLevel.SystemRequired:
                    this.requiredLevel = XrmRequirementLevel.ApplicationRequired;
                    break;
                default:
                    this.requiredLevel = XrmRequirementLevel.None;
                    break;
            }

            // Check attribute types and update accordingly
            if (attributeMetaData.GetType() == typeof(IntegerAttributeMetadata))
            {
                // Check if Min/Max values are set - some system fields have these set to null e.g. trackingtokeniddigits
                if (((IntegerAttributeMetadata)attributeMetaData).MinValue != null
                    && ((IntegerAttributeMetadata)attributeMetaData).MaxValue != null)
                {
                    this.minValue = ((IntegerAttributeMetadata)attributeMetaData).MinValue.Value;
                    this.maxValue = ((IntegerAttributeMetadata)attributeMetaData).MaxValue.Value;
                }
            }
            else if (attributeMetaData.GetType() == typeof(DecimalAttributeMetadata))
            {
                this.minValue = ((DecimalAttributeMetadata)attributeMetaData).MinValue.Value;
                this.maxValue = ((DecimalAttributeMetadata)attributeMetaData).MaxValue.Value;
            }
            else if (attributeMetaData.GetType() == typeof(BooleanAttributeMetadata))
            {
                this.booleanMetaData = (BooleanAttributeMetadata)attributeMetaData;
            }
            else if (attributeMetaData.GetType() == typeof(StringAttributeMetadata))
            {
                this.length = ((StringAttributeMetadata)attributeMetaData).MaxLength.Value;
            }
            else if (attributeMetaData.GetType() == typeof(PicklistAttributeMetadata))
            {
                this.optionSetMetaData = (PicklistAttributeMetadata)attributeMetaData;
            }
        }

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
            try
            {
                for (int c = 0; c < this.optionSetMetaData.OptionSet.Options.Count; c++)
                {
                    if (this.optionSetMetaData.OptionSet.Options[c].Value.Value == optionSetValue)
                    {
                        string optionSetValueLabel = this.optionSetMetaData.OptionSet.Options[c].Label.UserLocalizedLabel.Label.ToString();
                        Assert.IsTrue(optionSetValueLabel == optionSetLabel, "The Option Set label for value " + optionSetValue + " is " + optionSetValueLabel + "; not " + optionSetLabel);
                        return this;
                    }
                }

                Assert.Fail("The OptionSet value: " + optionSetValue + " is not in the Options for the " + this.LogicalName + " attribute");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
            }

            return this;
        }

        #endregion
    }
}
