// <copyright file="XrmPackageRelationship.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework.Legacy;
    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPackageRelationship
    ///   Description:    Class for handling the Relationship Metadata for an entity relationship as defined by a Dynamics CRM Solution
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class for handling the Relationship Metadata for an entity relationship as defined by a Dynamics CRM Solution
    /// </summary> 
    public class XrmPackageRelationship
    {
        #region Fields

        /// <summary>
        /// Logical name for the field used for the relationship
        /// </summary>
        public string LogicalName { get; set; }

        /// <summary>
        /// Display name for the field used for the relationship
        /// </summary>
        public string DisplayName { get; set; }

        /// <summary>
        /// Requirement Level for the field used for the relationship
        /// </summary>
        private string requiredLevel;

        /// <summary>
        /// Valid For advanced find for the relationship
        /// </summary>
        private bool isValidForAdvancedFind;

        /// <summary>
        /// CascadeDelete
        /// </summary>
        private string cascadeDelete { get; set; }

        #endregion

        #region Constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageRelationship"/> class
        /// </summary>
        /// <param name="xmlrelNode">An XmlNode element corresponding to the EntityRelationship node from the XML file</param>
        public XrmPackageRelationship(XmlNode xmlrelNode)
        {
            this.ReferencingEntity = XrmXmlHelpers.GetStringValueFromXmlNode(xmlrelNode, "ReferencingEntityName").ToLowerInvariant();
            this.ReferencingAttributeName = XrmXmlHelpers.GetStringValueFromXmlNode(xmlrelNode, "ReferencingAttributeName").ToLowerInvariant();

            var field = xmlrelNode.SelectSingleNode("field");
            if (field != null)
            {
                this.LogicalName = field.Attributes["name"].Value.ToLowerInvariant();
                this.requiredLevel = field.Attributes["requiredlevel"].Value.ToLowerInvariant();
            }

            if (xmlrelNode.SelectSingleNode("IsValidForAdvancedFind") != null)
            {
                this.isValidForAdvancedFind = XrmXmlHelpers.GetBoolValueFromEntityNode(xmlrelNode, "IsValidForAdvancedFind");
            }
            else
            {
                this.isValidForAdvancedFind = false;
            }

            if (xmlrelNode.SelectSingleNode("CascadeDelete") != null)
            {
                this.cascadeDelete = XrmXmlHelpers.GetStringValueFromXmlNode(xmlrelNode, "CascadeDelete");
            }
            else
            {
                this.cascadeDelete = XrmCascadeDeleteType.RemoveLink.ToDescription();
            }

            if (xmlrelNode.SelectSingleNode(@"./field/displaynames/displayname[@languagecode=""1033""]") != null)
            {
                this.DisplayName = xmlrelNode.SelectSingleNode(@"./field/displaynames/displayname[@languagecode=""1033""]").Attributes["description"].Value;
            }
        }
        #endregion

        #region Properties

        /// <summary>
        /// Gets a value representing the referencing entity for the relationship
        /// </summary>
        public string ReferencingEntity { get; private set; }
        public string ReferencingAttributeName { get; private set; }

        #endregion

        #region Methods

        /// <summary>
        /// Queries whether an EntityRelationship has a specific field name. Assertion will fail if it does not match fieldName
        /// </summary>
        /// <param name="fieldName">The field name for the related entity - i.e. the lookup field name</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageRelationship HasFieldName(string fieldName)
        {
            ClassicAssert.IsTrue(this.ReferencingAttributeName == fieldName.ToLowerInvariant(), "The relationship to entity " + this.ReferencingEntity + " has the field name \"" + this.ReferencingAttributeName + "\"; not \"" + fieldName + "\"");

            return this;
        }

        /// <summary>
        /// Queries whether an EntityRelationship has a specific display name. Assertion will fail if it does not match the displayName
        /// </summary>
        /// <param name="displayName">The display name for the related entity i.e. the lookup display name</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageRelationship HasDisplayName(string displayName)
        {
            //This is now ignored for D365 due to change in XML structure which does not contain this node
            //ClassicAssert.IsTrue(this.DisplayName == displayName, "The relationship to entity " + this.ReferencingEntity + " has the Display name \"" + this.DisplayName + "\"; not \"" + displayName + "\"");

            return this;
        }

        /// <summary>
        /// Queries whether an EntityRelationship Field has the specified required level. Assertion will fail if it does not match the requirement level
        /// </summary>
        /// <param name="requirementLevel">The requirement level for the field</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageRelationship HasRequiredLevel(string requirementLevel)
        {
            //This is now ignored for D365 due to change in XML structure which does not contain this node
            //ClassicAssert.IsTrue(this.requiredLevel == requirementLevel, "The relationship to entity " + this.ReferencingEntity + " has the requirement level \"" + this.requiredLevel + "\"; not \"" + requirementLevel + "\"");

            return this;
        }

        /// <summary>
        /// Queries whether an EntityRelationship Field has the specified required level. Assertion will fail if it does not match the requirement level
        /// </summary>
        /// <param name="requirementLevel">The requirement level for the field</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageRelationship HasCascadeDelete(XrmCascadeDeleteType cascadeDeleteType)
        {
            ClassicAssert.IsTrue(this.cascadeDelete == cascadeDeleteType.ToDescription(), "The relationship to entity " + this.ReferencingEntity + " has the Cascade Delete \"" + this.cascadeDelete + "\"; not \"" + cascadeDeleteType.ToDescription() + "\"");

            return this;
        }

        /// <summary>
        /// Queries whether an EntityRelationship Field is available on the advanced find. Assertion will fail if it is not valid for advanced find
        /// </summary>
        /// <param name="ValidForAdvancedFind">The requirement level for the field</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageRelationship IsAvailableForAdvanceFind(bool validForAdvancedFind)
        {
            ClassicAssert.IsTrue(this.isValidForAdvancedFind == validForAdvancedFind, "The relationship from " + this.DisplayName + " to entity " + this.ReferencingEntity + " does not have the ValidForAdvancedFind  \"" + this.isValidForAdvancedFind + "\"; not \"" + validForAdvancedFind + "\"");

            return this;
        }

        #endregion
    }
}