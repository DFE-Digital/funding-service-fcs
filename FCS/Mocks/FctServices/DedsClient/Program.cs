using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DedsClient.DedsSearchService;

namespace DedsClient
{
    class Program
    {
        static void Main(string[] args)
        {
            while (true)
            {
                Client client = new Client();
                Console.Clear();
                client.Execute();
            }
        }
    }
}
