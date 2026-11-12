// <copyright file="XrmPackageEntity.cs" company="Ciber">
//     Company Copyright
// </copyright>

using System.Collections.Generic;
using System.Linq;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework.Legacy;

namespace SFA.FCT.Xrm.TestFramework
{
    // Using statements for Assertions

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPackageEntity
    ///   Description:    Class for handing the Entity Metadata for a single Dynamics CRM entity
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for handling Dynamics CRM Configuration of a single Dynamics CRM entity
    /// </summary>
    public class XrmPackageEntity
    {
        #region Fields

        /// <summary>
        /// List of XrmPackageView Objects
        /// </summary>
        private List<XrmPackageView> views;

        /// <summary>
        /// List of XrmPackageRelationship Objects
        /// </summary>
        private List<XrmPackageRelationship> relationships;

        /// <summary>
        /// List of Form Objects
        /// </summary>
        private List<XrmPackageForm> forms;

        /// <summary>
        /// List of XrmPackageRibbon Objects
        /// </summary>
        private List<XrmPackageRibbon> ribbons;

        /// <summary>
        /// List of XrmAttribute Objects
        /// </summary>
        private List<XrmPackageAttribute> attributes;

        /// <summary>
        /// Gets the Object Type Code of the Entity
        /// </summary>
        private int objectTypeCode;

        /// <summary>
        /// Gets a value indicating whether the entity is an Activity Type
        /// </summary>
        private bool isActivityEntity;

        /// <summary>
        /// Gets a value indicating whether the entity is Audit Enabled
        /// </summary>
        private bool isAuditEnabled;

        /// <summary>
        /// Gets a value indicating whether the entity is Audit Enabled
        /// </summary>
      //  private bool isValidForAdvancedFind;

        private bool isUserOwned;

        private XrmPackageConfiguration xrmPackageConfiguration;

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageEntity"/> class - used for querying entities and attributes
        /// </summary>
        /// <param name="entityPath">Path to the entity folder</param>
        /// <param name="xrmPackageConfiguration">XrmPackageConfiguration</param>
        public XrmPackageEntity(string entityPath, XrmPackageConfiguration xrmPackageConfiguration)
        {
            this.xrmPackageConfiguration = xrmPackageConfiguration;

            // Parse directories to get Logical Name
            string dirName = new System.IO.DirectoryInfo(entityPath).Name;
            this.LogicalName = dirName.ToLower();

            // Open document
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.Load(entityPath + @"\Entity.xml");

            // Read Entity Properties
            this.DisplayName = xmlDocument.SelectSingleNode("//Entity/Name").Attributes["LocalizedName"].Value;
            //VB this.objectTypeCode = int.Parse(xmlDocument.SelectSingleNode("/Entity/ObjectTypeCode").InnerText);
            this.isActivityEntity = XrmXmlHelpers.GetBoolValueFromEntityNode(xmlDocument, "//Entity/EntityInfo/entity/IsActivity");
            this.isAuditEnabled = XrmXmlHelpers.GetBoolValueFromEntityNode(xmlDocument, "//Entity/EntityInfo/entity/IsAuditEnabled");
            this.isUserOwned = (XrmXmlHelpers.GetStringValueFromXmlNode(xmlDocument, "//Entity/EntityInfo/entity/OwnershipTypeMask") == "UserOwned");

            // Setup Paths
            string relationshipsFileName = xrmPackageConfiguration.relationshipsPath + @"\" + this.LogicalName + @".xml";
            string viewDirName = entityPath + @"\SavedQueries\";
            string mainFormDirName = entityPath + @"\FormXml\main\";
            string mobileFormDirName = entityPath + @"\FormXml\mobile\";
            string quickFormDirName = entityPath + @"\FormXml\quick\";
            string ribbonDiffFileName = entityPath + @"\RibbonDiff.xml";

            // Load Attributes
            this.LoadAttributes(xmlDocument.SelectNodes("//Entity/EntityInfo/entity/attributes/attribute"), xrmPackageConfiguration.optionsetPath);

            // Load Relationships
            this.LoadRelationships(relationshipsFileName);

            // Load Views
            this.LoadViews(viewDirName);

            // Load Forms
            this.LoadForms(mainFormDirName, mobileFormDirName, quickFormDirName);

            // Load Ribbon Diff
            this.LoadRibbons(ribbonDiffFileName);

        }

        #endregion

        #region Properties

        /// <summary>
        /// Gets the logical name for the entity
        /// </summary>
        public string LogicalName { get; set; }

        /// <summary>
        /// Gets the Display name of the Entity
        /// </summary>
        public string DisplayName { get; set; }

        #endregion

        #region Methods

        /// <summary>
        /// Loads a specified set of attributes using the Xml and OptionSet list provided
        /// </summary>
        /// <param name="attributeXml">An XmlNodeList consisting of the attributes to be added</param>
        /// <param name="optionSetPath">The path to the optionset folder for populating optionset values</param>
        private void LoadAttributes(XmlNodeList attributeXml, string optionSetPath)
        {
            var xrmPackageAttributes = new List<XrmPackageAttribute>();

            // Load attributes metadata info into Attributes Array
            foreach (XmlNode x in attributeXml)
            {
                xrmPackageAttributes.Add(new XrmPackageAttribute(x, optionSetPath));
            }

            if (this.isActivityEntity)
            {
                xrmPackageAttributes.Add(new XrmPackageAttribute("regardingobjectid", true, null, "Regarding"));
                xrmPackageAttributes.Add(new XrmPackageAttribute("subject", true, null, "Subject"));
                xrmPackageAttributes.Add(new XrmPackageAttribute("description", true, null, "Description"));
                xrmPackageAttributes.Add(new XrmPackageAttribute("createdon", true, null, "Created On") { dataType = XrmDataType.DateTime });
                xrmPackageAttributes.Add(new XrmPackageAttribute("createdby", true, null, "Created By"));
                xrmPackageAttributes.Add(new XrmPackageAttribute("modifiedon", true, null, "Modified On"));
                xrmPackageAttributes.Add(new XrmPackageAttribute("modifiedby", true, null, "Modified By") { dataType = XrmDataType.DateTime });
                xrmPackageAttributes.Add(new XrmPackageAttribute("owninguser", true, null, "Owning User"));
                xrmPackageAttributes.Add(new XrmPackageAttribute("ownerid", true, null, "Owner") { dataType = XrmDataType.Owner });

            }
            // Load attributes into list
            this.attributes = xrmPackageAttributes;
        }

        /// <summary>
        /// Load a specified set of forms using the two form directories
        /// </summary>
        /// <param name="mainFormDirName">Directory for the main forms</param>
        /// <param name="mobileFormDirName">Directory for the mobile forms</param>
        private void LoadForms(string mainFormDirName, string mobileFormDirName, string quickFormDirName)
        {
            List<XrmPackageForm> formList = new List<XrmPackageForm>();

            // Loop through Main Form Directory
            if (System.IO.Directory.Exists(mainFormDirName))
            {
                foreach (string f in System.IO.Directory.GetFiles(mainFormDirName))
                {
                    XmlDocument formXmlDoc = new XmlDocument();
                    formXmlDoc.Load(f);
                    formList.Add(new XrmPackageForm(this.LogicalName, formXmlDoc, XrmFormType.Main));
                }
            }

            // Loop through Mobile Form Directory
            if (System.IO.Directory.Exists(mobileFormDirName))
            {
                foreach (string f in System.IO.Directory.GetFiles(mobileFormDirName))
                {
                    XmlDocument formXmlDoc = new XmlDocument();
                    formXmlDoc.Load(f);
                    formList.Add(new XrmPackageForm(this.LogicalName, formXmlDoc, XrmFormType.Mobile));
                }
            }

            if (System.IO.Directory.Exists(quickFormDirName))
            {
                foreach (string f in System.IO.Directory.GetFiles(quickFormDirName))
                {
                    XmlDocument formXmlDoc = new XmlDocument();
                    formXmlDoc.Load(f);
                    formList.Add(new XrmPackageForm(this.LogicalName, formXmlDoc, XrmFormType.QuickView));
                }
            }
            // Load forms into array
            this.forms = formList;
        }

        /// <summary>
        /// Load views for the specified entity using the view directory specified
        /// </summary>
        /// <param name="viewPath">Path for the saved queries</param>
        private void LoadViews(string viewPath)
        {
            List<XrmPackageView> viewList = new List<XrmPackageView>();
            if (System.IO.Directory.Exists(viewPath))
            {
                foreach (string f in System.IO.Directory.GetFiles(viewPath))
                {
                    XmlDocument viewXmlDoc = new XmlDocument();
                    viewXmlDoc.Load(f);
                    viewList.Add(new XrmPackageView(viewXmlDoc, this));
                }
            }

            // Load views into array
            this.views = viewList;

        }

        /// <summary>
        /// Load relationships for the specified entity using the relationships File specified
        /// </summary>
        /// <param name="relationshipsPath">A path to the relationships file for the entity</param>
        private void LoadRelationships(string relationshipsPath)
        {
            if (System.IO.File.Exists(relationshipsPath))
            {
                XmlDocument relationshipsXml = new XmlDocument();
                relationshipsXml.Load(relationshipsPath);

                List<XrmPackageRelationship> xrmPackageRelationships = new List<XrmPackageRelationship>();

                foreach (XmlNode x in relationshipsXml.SelectNodes("//EntityRelationships/EntityRelationship"))
                {
                    xrmPackageRelationships.Add(new XrmPackageRelationship(x));
                }

                // Load relationships into array
                this.relationships = xrmPackageRelationships;
            }
        }

        /// <summary>
        /// Load ribbons for the specified entity using the view directory specified
        /// </summary>
        /// <param name="ribbonFileName">The path to the RibbonDiff.xml file for the entity</param>
        private void LoadRibbons(string ribbonFileName)
        {
            if (System.IO.File.Exists(ribbonFileName))
            {
                List<XrmPackageRibbon> xrmPackageRibbons = new List<XrmPackageRibbon>();

                xrmPackageRibbons.Add(new XrmPackageRibbon(ribbonFileName, this.LogicalName, XrmRibbonType.Form));
                xrmPackageRibbons.Add(new XrmPackageRibbon(ribbonFileName, this.LogicalName, XrmRibbonType.SubGrid));
                xrmPackageRibbons.Add(new XrmPackageRibbon(ribbonFileName, this.LogicalName, XrmRibbonType.HomepageGrid));

                // Load ribbons into array
                this.ribbons = xrmPackageRibbons;
            }
        }

        /// <summary>
        /// Verifies that the entity has the required display name. Assertion will fail if the entity display name does not match the passed in parameter
        /// </summary>
        /// <param name="displayNameString">Display name of the entity</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageEntity HasDisplayName(string displayNameString)
        {
            ClassicAssert.IsTrue(this.DisplayName == displayNameString, "The Display Name for entity " + this.LogicalName + " is \"" + this.DisplayName + "\"; not \"" + displayNameString + "\"");
            return this;
        }

        /// <summary>
        /// Verifies that the entity has the required ObjectTypeCode. Assertion will fail if the entity OTC does not match the passed in parameter.
        /// </summary>
        /// <param name="objectTypeCode">OTC of the entity</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageEntity HasObjectTypeCode(int objectTypeCode)
        {
            ClassicAssert.IsTrue(this.objectTypeCode == objectTypeCode, "The OTC for entity " + this.LogicalName + " is " + this.objectTypeCode + "; not " + objectTypeCode);
            return this;
        }

        /// <summary>
        /// Verifies that the entity is an Activity Type. Assertion will fail if the entity is not an activity.
        /// </summary>
        /// <returns>An instance of itself</returns>
        public XrmPackageEntity IsActivity()
        {
            ClassicAssert.IsTrue(this.isActivityEntity, "The entity " + this.LogicalName + " is not an activity type");
            return this;
        }

        /// <summary>
        /// Verifies that the entity is audit enabled. Assertion will fail if the entity is not audit-enabled 
        /// </summary>
        /// <returns>An instance of itself</returns>
        public XrmPackageEntity IsAuditEnabled()
        {
            ClassicAssert.IsTrue(this.isAuditEnabled, "The entity " + this.LogicalName + " is not audit enabled");
            return this;
        }

        public XrmPackageEntity IsUserOwned()
        {
            ClassicAssert.IsTrue(this.isUserOwned, "The entity " + this.LogicalName + " is not user owned");
            return this;
        }

        public XrmPackageEntity IsOrganisationOwned()
        {
            ClassicAssert.IsTrue(!this.isUserOwned, "The entity " + this.LogicalName + " is not Organisation owned");
            return this;
        }

        /// <summary>
        /// Overridden method for retrieving an XrmPackageView from the XrmEntity Object
        /// </summary>
        /// <param name="viewName">The name of the view</param>
        /// <returns>The XrmPackageView corresponding to the parameter</returns>
        public XrmPackageView View(string viewName)
        {
            var viewMatch = from v in this.views where v.ViewName == viewName select v;

            ClassicAssert.IsTrue(viewMatch.Any(), "The View " + viewName + " was not found in the Dynamics CRM Configuration");
            return (XrmPackageView)viewMatch.First();
        }

        /// <summary>
        /// Overridden method for retrieving the Quick Find View from the XrmEntity object
        /// </summary>
        /// <returns>The Quick Find view for the Entity</returns>
        public XrmPackageView QuickView()
        {
            var viewMatch = from v in this.views where v.IsQuickFind == true select v;
            ClassicAssert.IsTrue(viewMatch.Any(), "The Quick View was not found in the Dynamics CRM Configuration");
            return (XrmPackageView)viewMatch.First();
        }

        /// <summary>
        /// Overridden method for retrieving the Quick Find View from the XrmEntity object
        /// </summary>
        /// <returns>The Quick Find view for the Entity</returns>
        public XrmPackageView DefaultView(XrmViewType viewType = XrmViewType.MainApplicationView)
        {
            string viewTypeString = viewType.ToDescription();

            var viewMatch = from v in this.views
                            where v.IsDefault == true
                            && v.QueryType == viewTypeString
                            select v;
            ClassicAssert.IsTrue(viewMatch.Any(), "The Default View was not found in the Dynamics CRM Configuration");
            return (XrmPackageView)viewMatch.First();
        }

        /// <summary>
        /// Overridden method for retieveing a relationship from the XrmEntity Object
        /// </summary>
        /// <param name="relationshipName">Name of the related entity</param>
        /// /// <param name="relationshipDisplayName">Name of the related entity</param>
        /// <returns>The XrmPackageRelationship corresponding to the parameter</returns>
        public XrmPackageRelationship Relationship(string relationshipName, string relationshipDisplayName = "")
        {
            ClassicAssert.IsTrue(this.relationships != null, "The Relationship with entity " + relationshipName + "  was not found in the Dynamics CRM Configuration");

            var relMatch = from r in this.relationships where r.ReferencingEntity == relationshipName.ToLowerInvariant() select r;

            //Display name is now ignored due to change in XML structure for D365 where node is not present
            if (!string.IsNullOrWhiteSpace(relationshipDisplayName))
            {
                relMatch = relMatch.Where(a => a.ReferencingAttributeName == relationshipDisplayName);
            }
            ClassicAssert.IsTrue(relMatch.Any(), "The Relationship with entity " + relationshipName + "  was not found in the Dynamics CRM Configuration");

            return (XrmPackageRelationship)relMatch.First();
        }

        /// <summary>
        /// Method for retrieving a CRM form from the XrmEntity object
        /// </summary>
        /// <param name="formName">The name of the form</param>
        /// <param name="formType">The form type - currently "main" or "mobile"</param>
        /// <returns>The XrmPackageForm object that matches the parameters</returns>
        public XrmPackageForm Form(string formName, string formType)
        {
            var formMatch = from f in this.forms where f.FormName == formName && f.FormType == formType select f;
            ClassicAssert.IsTrue(formMatch.Any(), "The Form " + formName + " for the " + this.LogicalName + " was not found in the Dynamics CRM Configuration");
            return (XrmPackageForm)formMatch.First();
        }

        /// <summary>
        /// Gets an attribute record from the attribute name
        /// </summary>
        /// <param name="attributeName">A string consisting of the attribute display or logical name</param>
        /// <returns></returns>
        public XrmPackageAttribute Attribute(string attributeName)
        {
            var attributeMatch = from a in this.attributes where a.LogicalName == attributeName select a;
            if (!attributeMatch.Any())
            {
                attributeMatch = from a in this.attributes where a.displayName == attributeName select a;
            }
            ClassicAssert.IsTrue(attributeMatch.Any(), "The Attribute " + attributeName + " was not found in the Dynamics CRM Configuration");
            return (XrmPackageAttribute)attributeMatch.First();
        }

        /// <summary>
        /// Gets an primary attribute record from the attribute name
        /// </summary>
        /// <returns></returns>
        public XrmPackageAttribute PrimaryAttribute()
        {
            var attributeMatch = from a in this.attributes where a.primaryKey select a;

            ClassicAssert.IsTrue(attributeMatch.Any(), "The primary key for " + this.DisplayName + " was not found in the Dynamics CRM Configuration");
            return (XrmPackageAttribute)attributeMatch.First();
        }

        /// <summary>
        /// Gets an primary attribute record from the attribute name
        /// </summary>
        /// <returns></returns>
        public XrmPackageAttribute IdAttribute()
        {
            var attributeMatch = from a in this.attributes where a.dataType == XrmDataType.PrimaryKey select a;

            ClassicAssert.IsTrue(attributeMatch.Any(), "The primary key for " + DisplayName + " was not found in the Dynamics CRM Configuration");
            return attributeMatch.First();
        }

        /// <summary>
        /// Method to return the XrmPackageRibbon from the Ribbon Type specified
        /// </summary>
        /// <param name="ribbonType">The type of the ribbon</param>
        /// <returns>The ribbon object corresponding to the type</returns>
        public XrmPackageRibbon Ribbon(XrmRibbonType ribbonType)
        {
            var ribbonMatch = from r in this.ribbons where r.RibbonType == ribbonType select r;
            ClassicAssert.IsTrue(ribbonMatch.Any(), "The Ribbon Type " + ribbonType.ToDescription() + " was not found for the entity " + this.DisplayName + " in the Dynamics CRM Configuration");
            return (XrmPackageRibbon)ribbonMatch.First();
        }

        public XrmPackageWorkflow Workflow(string workflowName)
        {
            var workflowMatch = from w in this.xrmPackageConfiguration.Workflows
                                where w.PrimaryEntity == this.LogicalName
                                && w.WorkflowName == workflowName
                                select w;

            ClassicAssert.IsTrue(workflowMatch.Any(), "The Workflow " + workflowName + " was not found for the entity " + this.DisplayName + " in the Dynamics CRM Configuration");
            return (XrmPackageWorkflow)workflowMatch.First();
        }
        #endregion
    }
}
