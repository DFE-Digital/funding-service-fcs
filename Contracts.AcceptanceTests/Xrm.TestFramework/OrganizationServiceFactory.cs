namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using Microsoft.Xrm.Sdk;

    public static class OrganizationServiceFactory
    {
        private static Func<IOrganizationService> _factoryMethod;

        public static void Initialize(Func<IOrganizationService> factoryMethod)
        {
            _factoryMethod = factoryMethod;
        }

        public static IOrganizationService GetOrganizationService()
        {
            if (_factoryMethod == null)
            {
                throw new Exception("Legacy Xrm.TestFramework.OrganizationServiceFactory not initialized");
            }

            return _factoryMethod();
        }
    }
}
