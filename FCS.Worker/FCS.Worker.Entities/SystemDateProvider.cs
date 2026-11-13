namespace SFA.FCS.Worker.Common
{
    using System;
  //  using FCT.CrossDomain.Integration.Entities.Data;
    //using FCT.CrossDomain.Integration.Entities.Time;

    public class SystemDateProvider// : IDateProvider
    {
        public DateTime GetDate(ConnectionInfo connectionInfo)
        {
            return DateTime.UtcNow;
        }
    }
}