// <copyright file="XrmConfiguration.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework.Legacy;

    // Using statements for Assertions

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests
    ///   Class:          XrmPackageWorkflow
    ///   Description:    Class for handling the loading of the 
    ///   Notes:          
    ///   Author:         Dean Holmes   
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for loading and validating the Dynamics CRM Configuration from the Dynamics CRM Web Service
    /// </summary> 
    public class XrmPackageWorkflow
    {
        #region Constructors

        public XrmPackageWorkflow(XmlDocument workflowXmlDoc)
        {
            try
            {
                var workflowNode = workflowXmlDoc.SelectSingleNode("//Workflow");

                this.WorkflowName = workflowNode.Attributes["Name"].Value;
                this.PrimaryEntity = workflowNode.SelectSingleNode("PrimaryEntity").InnerText;
                string triggerOnUpdateAttributeList = XrmXmlHelpers.GetStringValueFromXmlNode(workflowNode, "TriggerOnUpdateAttributeList ");

                if (!string.IsNullOrWhiteSpace(triggerOnUpdateAttributeList))
                {
                    this.TriggerOnUpdateAttributeList = triggerOnUpdateAttributeList.Split(',').ToList();
                }

                this.TriggerOnCreate = XrmXmlHelpers.GetBoolValueFromEntityNode(workflowNode, "TriggerOnCreate");
                this.TriggerOnDelete = XrmXmlHelpers.GetBoolValueFromEntityNode(workflowNode, "TriggerOnDelete");
                this.OnDemand = XrmXmlHelpers.GetBoolValueFromEntityNode(workflowNode, "OnDemand");
                this.SynchronousWorkflow = XrmXmlHelpers.GetBoolValueFromEntityNode(workflowNode, "Mode");
                this.RunAs = XrmXmlHelpers.GetBoolValueFromEntityNode(workflowNode, "RunAs");
                this.Scope = XrmXmlHelpers.GetStringValueFromXmlNode(workflowNode, "Scope");
            }
            catch (Exception ex)
            {
                Console.WriteLine("An Error Occurred: {0}", ex.Message);
            }
        }

        #endregion

        #region Properties

        public string WorkflowName { get; private set; }

        public string PrimaryEntity { get; private set; }

        public List<string> TriggerOnUpdateAttributeList { get; private set; }

        public bool TriggerOnCreate { get; private set; }

        public bool TriggerOnDelete { get; private set; }

        public bool OnDemand { get; private set; }

        public bool SynchronousWorkflow { get; private set; }

        public bool RunAs { get; private set; }

        public string  Scope { get; private set; }

        #endregion

        #region Methods

        public XrmPackageWorkflow IsSynchronousProcess()
        {
            ClassicAssert.IsTrue(this.SynchronousWorkflow, "The Workflow : " + this.WorkflowName + " is not Synchronous");
            return this;
        }

        public XrmPackageWorkflow IsBackgroundProcess()
        {
            ClassicAssert.IsFalse(this.SynchronousWorkflow, "The Workflow : " + this.WorkflowName + " is not a Background Process");
            return this;
        }

        public XrmPackageWorkflow IsPrimaryEntity(string primiaryentityname)
        {
            ClassicAssert.AreEqual(this.PrimaryEntity.ToLower(), primiaryentityname.ToLower(), "The Workflow : " + this.WorkflowName + " Primary Entity is not " + this.PrimaryEntity );
            return this;
        }

        public XrmPackageWorkflow TriggerOnUpdateAttributeListContain(List<string> triggerAttributes)
        {
            ClassicAssert.IsTrue( this.TriggerOnUpdateAttributeList.TrueForAll(triggerAttributes.Contains) &&
                          triggerAttributes.TrueForAll(this.TriggerOnUpdateAttributeList.Contains),
                          "The workflow : " + this.WorkflowName + " TriggerOnUpdateAttributeList does not match as expected :"  + String.Join(",", triggerAttributes));
            return this;
        }

        public XrmPackageWorkflow ProcessRunAs(WorkflowRunAs runas)
        {
            var result = (this.RunAs) ? "The uesr who made changes to the record" : "The owner of the workflow";
            ClassicAssert.AreEqual( Convert.ToInt32(this.RunAs), (int)runas, "The Workflow : " + this.WorkflowName + " is not configured run as " + result );
            return this;
        }


        #endregion
    }

    public enum WorkflowRunAs
    {
        Theowneroftheworkflow = 0,
        Theuserwhomadechangestotherecord =1
    }

}