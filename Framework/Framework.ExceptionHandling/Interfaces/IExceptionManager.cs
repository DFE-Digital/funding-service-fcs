using System;

namespace SFA.FCT.Framework.ExceptionHandling.Interfaces
{
    public interface IExceptionManager
    {
        bool Publish(Exception ex);

    }
}
