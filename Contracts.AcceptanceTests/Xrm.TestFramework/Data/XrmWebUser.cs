// <copyright file="XrmWebUser.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using NUnit.Framework.Legacy;

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmWebEntity
    ///   Description:    Class for handing the Entity Metadata for a single Dynamics CRM entity
    ///   Notes:          
    ///   Author:         Dean Holmes
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for handling Dynamics CRM Configuration of a single Dynamics CRM entity
    /// </summary>
    public class XrmWebUser
    {
        private Entity entity;
        private CrmOrganisationService crmOrganisationService;
        private Guid systemUserGuid;
        private string systemUserFullName;
        private RolePrivilege[] rolePrivs;
        private EntityCollection allPrivs;

        #region Constructors

        public XrmWebUser(CrmOrganisationService crmOrganisationService, string systemUserFullName)
        {
            this.crmOrganisationService = crmOrganisationService;
            this.systemUserFullName = systemUserFullName;

            this.GetData(systemUserFullName);

            RetrieveUserPrivilegesRequest privRequest = new RetrieveUserPrivilegesRequest()
            {
                UserId = this.systemUserGuid
            };

            RetrieveUserPrivilegesResponse privResponse =
                (RetrieveUserPrivilegesResponse)this.crmOrganisationService.Execute(privRequest);

            RetrievePrivilegeSetRequest allPrivRequest = new RetrievePrivilegeSetRequest();

            RetrievePrivilegeSetResponse allPrivResponse =
                (RetrievePrivilegeSetResponse)this.crmOrganisationService.Execute(allPrivRequest);

            this.allPrivs = allPrivResponse.EntityCollection;

            this.rolePrivs = privResponse.RolePrivileges;
        }

        #endregion

        #region Methods

        public XrmWebUser HasPrivilege(string entityLogicalName, XrmSecurityAction securityAction, XrmSecurityPriv securityPriv)
        {
            Guid privId = this.LookupPrivilege(entityLogicalName, securityAction);

            var p = this.rolePrivs.Where(
                x =>
                    x.PrivilegeId == privId);

            if (securityPriv == XrmSecurityPriv.None)
            {
                ClassicAssert.IsFalse(
                    p.Any(),
                    "The privilege on the entity " + entityLogicalName + " for user " + this.systemUserFullName +
                    " for action " + securityAction.ToDescription() + " is not " +
                    XrmSecurityPriv.None.ToDescription());
            }
            else
            {
                ClassicAssert.IsTrue(
                    p.Any(),
                    "The privilege on the entity " + entityLogicalName + " for user " + this.systemUserFullName +
                    " for action " + securityAction.ToDescription() +
                    " is " + XrmSecurityPriv.None.ToDescription() + "; not " + securityPriv.ToDescription());
                string privDepth = p.First().Depth.ToString();

                ClassicAssert.IsTrue(
                    privDepth == securityPriv.ToDescription(),
                    "The privilege on the entity " + entityLogicalName + " for user " + this.systemUserFullName + " for action " + securityAction.ToDescription() +
                    " is " + privDepth + "; not " + securityPriv.ToDescription());
            }

            return this;
        }

        private Guid LookupPrivilege(string entityLogicalName, XrmSecurityAction action)
        {
            string privString = new System.Text.StringBuilder("prv").Append(action.ToDescription()).Append(entityLogicalName).ToString();

            var privMatch = this.allPrivs.Entities.AsEnumerable().Where(p => p.Attributes["name"].ToString() == privString);

            ClassicAssert.IsTrue(privMatch.Any(), "The privilege does not exist within Dynamics CRM");

            return (Guid)privMatch.First().Attributes["privilegeid"];
        }

        private void GetData(string fullName)
        {
            QueryExpression query = new QueryExpression("systemuser")
            {
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };
            query.Criteria.AddCondition("fullname", ConditionOperator.Equal, fullName);

            try
            {
                EntityCollection entityCollection = this.crmOrganisationService.RetrieveMultiple(query);

                ClassicAssert.IsTrue(entityCollection != null && entityCollection.Entities.Count == 1, "The user does not exist within Dynamics CRM");

                this.entity = entityCollection.Entities[0];
                this.systemUserGuid = (Guid)entityCollection.Entities[0].Attributes["systemuserid"];
            }
            catch (FaultException<Microsoft.Xrm.Sdk.OrganizationServiceFault> ex)
            {
                Console.WriteLine("The application terminated with an error.");
                Console.WriteLine("Timestamp: {0}", ex.Detail.Timestamp);
                Console.WriteLine("Code: {0}", ex.Detail.ErrorCode);
                Console.WriteLine("Message: {0}", ex.Detail.Message);
                Console.WriteLine("Inner Fault: {0}", null == ex.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                ClassicAssert.Fail("Organization Service Fault " + ex.Detail.Message);
            }
            catch (System.TimeoutException ex)
            {
                Console.WriteLine("The application terminated with an error.");
                Console.WriteLine("Message: {0}", ex.Message);
                Console.WriteLine("Stack Trace: {0}", ex.StackTrace);
                Console.WriteLine("Inner Fault: {0}", null == ex.InnerException.Message ? "No Inner Fault" : ex.InnerException.Message);

                ClassicAssert.Fail("Timeout Exception " + ex.Message);
            }
            catch (System.Exception ex)
            {
                Console.WriteLine("The application terminated with an error.");
                Console.WriteLine(ex.Message);

                // Display the details of the inner exception.
                if (ex.InnerException != null)
                {
                    Console.WriteLine(ex.InnerException.Message);

                    FaultException<Microsoft.Xrm.Sdk.OrganizationServiceFault> fe = ex.InnerException
                        as FaultException<Microsoft.Xrm.Sdk.OrganizationServiceFault>;
                    if (fe != null)
                    {
                        Console.WriteLine("Timestamp: {0}", fe.Detail.Timestamp);
                        Console.WriteLine("Code: {0}", fe.Detail.ErrorCode);
                        Console.WriteLine("Message: {0}", fe.Detail.Message);
                        Console.WriteLine("Trace: {0}", fe.Detail.TraceText);
                        Console.WriteLine("Inner Fault: {0}", null == fe.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                        ClassicAssert.Fail("OrganizatioServiceFault Exception: " + fe.Detail.Message);
                    }
                }
            }
        }

        #endregion
    }
}
