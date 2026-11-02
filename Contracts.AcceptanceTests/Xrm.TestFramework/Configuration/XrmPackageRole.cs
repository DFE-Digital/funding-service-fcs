// <copyright file="XrmConfiguration.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    // Using statements for Assertions

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.Security
    ///   Class:          XrmPackageRole
    ///   Description:    Class for handling the loading of the 
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for loading and validating the Dynamics CRM Configuration from the Dynamics CRM Web Service
    /// </summary> 
    public class XrmPackageRole
    {

        #region Fields

        private Dictionary<string, string> privs;

        #endregion

        #region Constructors

        public XrmPackageRole(XmlDocument securityXmlDocument)
        {
            try
            {
                Dictionary<string, string> privDic = new Dictionary<string, string>();

                this.RoleName = securityXmlDocument.SelectSingleNode("//Role").Attributes["name"].Value;

                foreach (XmlNode r in securityXmlDocument.SelectNodes("//Role/RolePrivileges/RolePrivilege"))
                {
                    string privName = r.Attributes["name"].Value;

                    string privLevel = r.Attributes["level"].Value;

                    privDic.Add(privName, privLevel);
                }

                this.privs = privDic;

            }
            catch (Exception ex)
            {
                Console.WriteLine("An Error Occurred: {0}", ex.Message);
            }
        }

        #endregion

        #region Properties

        public string RoleName { get; set; }

        #endregion

        #region Methods

        public XrmPackageRole HasPrivilege(string entity, XrmSecurityAction action, XrmSecurityPriv priv)
        {
            string actionString = new StringBuilder("prv").Append(action.ToDescription()).Append(entity).ToString();
            string privString = priv.ToDescription();


            if (priv == XrmSecurityPriv.None)
            {
                var privMatch = (from p in this.privs
                    where p.Key == actionString
                    select p);

                Assert.IsFalse(privMatch.Any(), "The Role : " + this.RoleName + " does not have the " + action.ToDescription() + " permission on the " + entity + " entity at the " + priv.ToDescription() + " level");
            }
            else
            {
                var privMatch = (from p in this.privs
                    where p.Key == actionString && p.Value == privString
                    select p);

                Assert.IsTrue(privMatch.Any(), "The Role : " + this.RoleName + " does not have the " + action.ToDescription() + " permission on the " + entity + " entity at the " + priv.ToDescription() + " level");
            }

            return this;
        }

        #endregion
    }
}