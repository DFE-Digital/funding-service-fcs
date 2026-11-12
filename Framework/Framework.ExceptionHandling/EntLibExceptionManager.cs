using System;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using SFA.FCT.Framework.ExceptionHandling.Interfaces;


namespace SFA.FCT.Framework.ExceptionHandling
{
    public class EntLibExceptionManager : IExceptionManager
    {
        public EntLibExceptionManager()
        {
            IConfigurationSource config = ConfigurationSourceFactory.Create();
            ExceptionPolicyFactory factory = new ExceptionPolicyFactory(config);
            Logger.SetLogWriter(new LogWriterFactory().Create(),false);

            var manager = factory.CreateManager();
            ExceptionPolicy.SetExceptionManager(manager,false);

        }

        public bool Publish(Exception ex)
        {
            return ExceptionPolicy.HandleException(ex, "Policy");
        }
    }
}
