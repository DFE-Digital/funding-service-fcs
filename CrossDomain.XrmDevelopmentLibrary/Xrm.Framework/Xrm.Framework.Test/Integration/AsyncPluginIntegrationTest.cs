using Microsoft.Xrm.Sdk;

namespace Xrm.Framework.Test.Integration
{
    /// <summary>
    ///     Base Class for all Asynchronous Plugins Integration Tests
    /// </summary>
    public abstract class AsyncPluginIntegrationTest : AsyncIntegrationTest
    {
        #region Properties

        protected override string AsyncOperationName
        {
            get { return GetType().Name.Replace("Test", ""); }
        }

        protected override int AsyncOperationType
        {
            get { return 1; }
        }

        #endregion

        #region Constructors

        public AsyncPluginIntegrationTest()
        {
        }

        public AsyncPluginIntegrationTest(IOrganizationService service)
            : base(service)
        {
        }

        #endregion
    }
}