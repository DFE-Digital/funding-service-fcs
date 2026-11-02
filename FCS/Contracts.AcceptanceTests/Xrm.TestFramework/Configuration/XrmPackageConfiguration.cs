// <copyright file="XrmPackageConfiguration.cs" company="Ciber">
//     Company Copyright
// </copyright>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SFA.FCT.Xrm.TestFramework
{
    using System.IO;

    // Using statements for Assertions

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPakcageConfiguration
    ///   Description:    Class for handling the loading of a Dynamics CRM Configuration - Loading from a solution file from the CrmPackager outputs
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for loading and validating the Dynamics CRM Configuration from the output of the Dynamics Crm Packager
    /// </summary> 
    public class XrmPackageConfiguration
    {
        #region Fields

        /// <summary>
        /// string corresponding to the path for the Option Set files
        /// </summary>
        public string optionsetPath { get; private set; }

        /// <summary>
        /// string corresponding to the path used for building lookup relationships
        /// </summary>
        public string relationshipsPath { get; private set; }

        /// <summary>
        /// string corresponding to the path used for the security roles
        /// </summary>
        private string rolePath;

        /// <summary>
        /// string coresponding to the path used for the dashboards
        /// </summary>
        private string dashboardPath;

        /// <summary>
        /// XrmEntity list field for the Entity MetaData to be queried
        /// </summary>
        private List<XrmPackageEntity> entities;

        /// <summary>
        /// List of XrmPackageRoles to represent security roles in the solution
        /// </summary>
        private List<XrmPackageRole> roles;

        /// <summary>
        /// List of XrmPackageRoles to represent security roles in the solution
        /// </summary>
        public List<XrmPackageWorkflow> Workflows { get; private set; }

        private List<XrmPackageDashboard> _dashboards;
        
        #endregion

        #region Constructors
        /// <summary>
        /// Initializes a new instance of the XrmPackageConfiguration class
        /// </summary>
        /// <param name="xrmSolutionPath">Solution Path for the Dynamics Xrm Solution - Unpackaged by CrmPackager</param>
        public XrmPackageConfiguration(string xrmSolutionPath)
        {
            if (!xrmSolutionPath.EndsWith(@"\"))
            {
                xrmSolutionPath += @"\";
            }

            Console.WriteLine("Loading CRM Solution from: {0}", Path.GetFullPath(xrmSolutionPath));

            // Load the entity paths
            string[] entityPaths = System.IO.Directory.GetDirectories(xrmSolutionPath + @"Entities\");

            // Load paths for the option sets into the Configuration Object
            this.optionsetPath = xrmSolutionPath + @"OptionSets\";
            this.relationshipsPath = xrmSolutionPath + @"Other\Relationships\";
            this.rolePath = xrmSolutionPath + @"Roles\";
            this.dashboardPath = xrmSolutionPath + @"Dashboards\";

            this.Workflows = new List<XrmPackageWorkflow>();
            string[] workflowPaths = new string[2]  { xrmSolutionPath + @"Workflows\", xrmSolutionPath + @"Workflows\1033\" };

            foreach (string workflowPath in workflowPaths)
            {
                // Load workflows into the roles list
                if (System.IO.Directory.Exists(workflowPath))
                {
                    var workflowsList = new List<XrmPackageWorkflow>();

                    foreach (string w in System.IO.Directory.GetFiles(workflowPath, "*.xml"))
                    {
                        try
                        {
                            XmlDocument workflowXmlDoc = new XmlDocument();
                            workflowXmlDoc.Load(w);
                            workflowsList.Add(new XrmPackageWorkflow(workflowXmlDoc));
                        }
                        catch (System.NullReferenceException ex)
                        {
                            Console.WriteLine("Error Occurred: {0}", ex.Message);
                        }
                    }

                    this.Workflows.AddRange(workflowsList);
                }
            }
            // Store paths in entities array field - pass in the OptionSet Path as these can be referenced by the entities & attributes
            this.entities =
                (from e in entityPaths select new XrmPackageEntity(e.ToString(), this))
                    .ToList();

            // Load Security Roles into the roles list
            if (System.IO.Directory.Exists(this.rolePath))
            {
                var rolesList = new List<XrmPackageRole>();

                foreach (string r in System.IO.Directory.GetFiles(this.rolePath,"*.xml"))
                {
                    try
                    {
                        XmlDocument roleXmlDoc = new XmlDocument();
                        roleXmlDoc.Load(r);
                        rolesList.Add(new XrmPackageRole(roleXmlDoc));
                    }
                    catch (System.NullReferenceException ex)
                    {
                        Console.WriteLine("Error Occurred: {0}",ex.Message);
                    }
                }

                this.roles = rolesList;
            }

            this.LoadDashboards(this.dashboardPath);
        }

        #endregion

        #region Methods

        /// <summary>
        /// Method to return the XrmPackageEntity Object corresponding to the entity logical name
        /// </summary>
        /// <param name="entityName">The Logical name of the entity</param>
        /// <returns>The XrmPackageEntity Object corresponding to the entity logical name</returns>
        public XrmPackageEntity Entity(string entityName)
        {
            var entityMatch = from e in this.entities where e.LogicalName == entityName select e;

            if (!entityMatch.Any())
            {
                entityMatch = from e in this.entities where e.DisplayName == entityName select e;
            }
            Assert.IsTrue(entityMatch.Any(), "The Entity " + entityName + " was not found in the Dynamics CRM Configuration");
            return entityMatch.First();
        }



        /// <summary>
        /// Method to return the XrmPackageWorkflow Object corresponding to the process logical name
        /// </summary>
        /// <param name="processName">The Logical name of the entity</param>
        /// <returns>The XrmPackageWorflow Object corresponding to the entity logical name</returns>
        public XrmPackageWorkflow Workflow(string processName)
        {
            var processMatch = from e in this.Workflows
                where e.WorkflowName == processName
                select e;

            if (!processMatch.Any())
            {
                processMatch = from e in this.Workflows where e.WorkflowName == processName select e;
            }
            Assert.IsTrue(processMatch.Any(), "The Process " + processName + " was not found in the Dynamics CRM Configuration");
            return processMatch.First();

        }



        /// <summary>
        /// Method to return the XrmPackageRole Object corresponding to the Role Name
        /// </summary>
        /// <param name="entityName">The Name of the role</param>
        /// <returns>The XrmPackageRole object corresponding to the role</returns>
        public XrmPackageRole SecurityRole(string roleName)
        {
            var roleMatch = from r in this.roles where r.RoleName == roleName select r;

            Assert.IsTrue(roleMatch.Any(), "The Role " + roleName + " was not found in the Dynamics CRM Configuration");
            return roleMatch.First();
        }

        /// <summary>
        /// Load Dashboards using the directory specified
        /// </summary>
        /// <param name="dashboardPath">Path for the dashboards</param>
        private void LoadDashboards(string dashboardPath)
        {
            List<XrmPackageDashboard> dashboardList = new List<XrmPackageDashboard>();
            if (System.IO.Directory.Exists(dashboardPath))
            {
                foreach (string f in System.IO.Directory.GetFiles(dashboardPath,"*.xml"))
                {
                    XmlDocument dashboardXmlDoc = new XmlDocument();
                    dashboardXmlDoc.Load(f);
                    dashboardList.Add(new XrmPackageDashboard(dashboardXmlDoc));
                }
            }

            // Load dashboards into list
            this._dashboards = dashboardList;
        }

        /// <summary>
        /// Method to return the XrmPackageDashboard Object corresponding to the Name
        /// </summary>
        /// <param name="dashboardName">The Name of the dashboard</param>
        /// <returns>The XrmPackageDashboard object corresponding to the role</returns>
        public XrmPackageDashboard Dashboard(string dashboardName)
        {
            var dashboardMatch = from d in _dashboards where d.Name  == dashboardName select d;

            Assert.IsTrue(dashboardMatch.Any(), "The Dashboard " + dashboardName + " was not found in the Dynamics CRM Configuration");
            return dashboardMatch.First();
        }


        #endregion
    }
}
