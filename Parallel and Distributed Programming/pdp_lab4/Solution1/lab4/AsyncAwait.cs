using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace lab4
{
    public class AsyncAwait
    {
        private List<string> Urls { get; }
        private string ParserType => "Async/Await";

        public AsyncAwait(List<string> urls)
        {
            Urls = urls;
            Run();
        }

        private void Run()
        {
            var count = 0;
            var function = (Func<int, string, Task>)((index, url) => Task.Run(() => Start(Parser.Create(url, index))));
            var tasks = Urls.Select(url => function(count++, url)).ToList();
            Task.WhenAll(tasks).Wait();
        }

        private async Task Start(Parser socket)
        {
            await socket.BeginConnectAsync();
            Console.WriteLine($"{ParserType}-{socket.Id}: Socket connected to {socket.BaseUrl} ({socket.UrlPath})");

            var numberOfSentBytes = await socket.BeginSendAsync();
            Console.WriteLine($"{ParserType}-{socket.Id}: Sent {numberOfSentBytes} bytes to server.");

            await socket.BeginReceiveAsync();
            Console.WriteLine($"{ParserType}-{socket.Id}: {socket.GetResponseContent}");

            socket.ShutdownAndClose();
        }
    }
}