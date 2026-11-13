using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.ContractRequestDomain.DataStore.Model
{
    public class WebjobStatus
    {
        public int Id { get; set; }
        public string Webjobname { get; set; }
        public bool Enabled { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
    }
}
