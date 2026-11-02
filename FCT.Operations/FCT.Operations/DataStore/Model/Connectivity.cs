using System;

namespace FCT.Operations.DataStore.Model
{
    public class Connectivity
    {
        private Connectivity()
        {
            
        }

        public string ServiceName { get; private set; }
        public bool CanConnect { get; private set; }
        public string ErrorInfo { get; private set; }
        public string SupplementaryInfo { get; private set; }
        public DateTime LastUpdated { get; private set; }
    }
}