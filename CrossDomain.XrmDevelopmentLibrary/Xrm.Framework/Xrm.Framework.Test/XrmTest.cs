using System;

namespace Xrm.Framework.Test
{
    /// <summary>
    ///     Base Class for Dynamics CRM Tests
    /// </summary>
    public abstract class XrmTest
    {
        #region Test

        protected virtual void Test()
        {
            Setup();

            try
            {
                Do();
            }
            catch (Exception ex)
            {
                Error = ex;

                if (ThrowError)
                    throw ex;
            }

            Verify();

            CleanUp();
        }

        #endregion

        #region Clean Up

        protected virtual void CleanUp()
        {
        }

        #endregion

        #region Properties

        protected Exception Error { get; private set; }

        protected virtual bool ThrowError
        {
            get { return false; }
        }

        #endregion

        #region Abstract Methods

        protected abstract void Setup();
        protected abstract void Do();
        protected abstract void Verify();

        #endregion
    }
}