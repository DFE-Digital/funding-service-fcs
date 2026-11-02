namespace SFA.FCT.PerformanceTests
{
  
    using System;
    using System.Collections.Generic;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.WebTesting;
    using System.Diagnostics;

    /// <summary>
    /// Contains helper methods for web performance tests. 
    ///  Web performance tests also have issues when attempting to read
    /// configuration files, so most of the setting are stored in this class.
    /// </summary>

    public static class ConfigurationParameters
    {
        /// <summary>
        /// Returns the full CRM URL path. It is capable of figuring out the path
        /// depending on the current project configuration.
        /// </summary>
        /// <returns>The full CRM URL path.</returns>

        public static string CrmUrl()
        {
            Debug.WriteLine("In ConfigurationParameters.CrmUrl() ...\n");
          
            #if OAT
            return "http://fct-crm-dev-01.cloudapp.net" ;
#elif CI
            return "http://fct-crm-dev-01.cloudapp.net" ;
#elif AT
            return "http://fct-at-crm-01.cloudapp.net";
#elif MO
            return "http://fct-crm-dev-01.cloudapp.net";
#elif PUB
            return "http://fct-crm-dev-01.cloudapp.net";
#elif COPYPROD
            return "http://fct-crm-dev-01.cloudapp.net";
#else
            return "http://fct-crm-dev-01.cloudapp.net";
            #endif
        }
        /// <summary>
        /// Returns the full BulkuploadDirectoryIn path. It is capable of figuring out the path
        /// depending on the current project configuration.
        /// </summary>
        /// <returns>The full BulkuploadDirectoryIn path.</returns>

        public static string BulkuploadDirectoryIn()
        {
           Debug.WriteLine("In ConfigurationParameters.BulkuploadDirectoryIn() ...\n");

            #if OAT
            return "https://skillsfundingagency.sharepoint.com/sites/partners/sfafcsdevelopment/" ;
#elif CI
           return "https://skillsfundingagency.sharepoint.com/sites/partners/sfafcsdevelopment/";
#elif AT
           return "https://skillsfundingagency.sharepoint.com/sites/partners/SFA%20AT/";
#elif MO
            return "https://skillsfundingagency.sharepoint.com/sites/partners/sfafcsdevelopment/";
#elif PUB
            return "https://skillsfundingagency.sharepoint.com/sites/partners/sfafcsdevelopment/";
#elif COPYPROD
            return "https://skillsfundingagency.sharepoint.com/sites/partners/sfafcsdevelopment/";
#else
            return "https://skillsfundingagency.sharepoint.com/sites/partners/sfafcsdevelopment/";
#endif
        }
        /// <summary>
        /// Returns the full BulkuploadDirectoryOut path. It is capable of figuring out the path
        /// depending on the current project configuration.
        /// </summary>
        /// <returns>The full BulkuploadDirectoryOut path.</returns>

        public static string BulkuploadDirectoryOut()
        {
           Debug.WriteLine("In ConfigurationParameters.BulkuploadDirectoryOut() ...\n");

#if OAT
            return "bulkupload-out-at";
#elif CI
           return "bulkupload-out-at";
#elif AT
           return "Bulkupload-out-at";
#elif MO
            return "http://fct-crm-dev-01.cloudapp.net";
#elif PUB
            return "http://fct-crm-dev-01.cloudapp.net";
#elif COPYPROD
            return "http://fct-crm-dev-01.cloudapp.net";
#else
            return "http://fct-crm-dev-01.cloudapp.net";
#endif
        }       /// <summary>
        /// Returns the path for DocumentGenerationWebservice. 
        /// 
        /// </summary>
        /// <returns>The full DocumentGenerationWebservice URL path.</returns>

        public static string DocumentGenerationServiceUrl()
        {
            Debug.WriteLine("In ConfigurationParameters.DocumentGenerationServiceUrl() ...\n");

            #if OAT
            return "http://localhost:2350" ;
#elif CI
            return "http://localhost:2350" ;
#elif AT
            return "http://localhost:2350";
#elif MO
            return "http://localhost:2350";
#elif PUB
            return "http://localhost:2350";
#else
            return "http://localhost:2350";
            #endif
        }
        /// <summary>
        /// Returns the path for DocumentConversionWebservice. 
        /// 
        /// </summary>
        /// <returns>The full DocumentConversionWebservice URL path.</returns>

        public static string DocumentConversionServiceUrl()
        {
            Debug.WriteLine("In ConfigurationParameters.DocumentConversionServiceUrl() ...\n");

#if OAT
            return "http://localhost:2350";
#elif CI
            return "http://localhost:2350";
#elif AT
            return "http://localhost:2350";
#elif MO
            return "http://localhost:2350";
#elif PUB
            return "http://localhost:2350";
#else
            return "http://localhost:2350";
#endif
        }       
       
       /// <summary>
        /// Returns the path for OrganisationWebservice. 

        /// </summary>
        /// <returns>The full OrganisationServiceWebservice URL path.</returns>

        public static string OrganisationServiceUrl()
        {
            Debug.WriteLine("In ConfigurationParameters.OrganisationServiceUrl() ...");
#if OAT
            return "http://fct-orgservice-oat.cloudapp.net/api/v1/organisations/ukprn/" ;
#elif CI
            return "http://fct-orgservice-ci.cloudapp.net/api/v1/organisations/ukprn/" ;
#elif AT
            return "http://fct-orgservice-at.cloudapp.net/api/v1/organisations/ukprn/";
#elif MO
            return "http://fct-orgservice-mo.cloudapp.net/api/v1/organisations/ukprn/";
#elif PUB
            return "http://fct-orgservice-pub.cloudapp.net/api/v1/organisations/ukprn/";
#else
            return "http://fct-orgservice-oat.cloudapp.net/api/v1/organisations/ukprn/";
#endif
        }
    }
}
