using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using System.ComponentModel.DataAnnotations;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using System.Web.Http.Description;

namespace CalculatorFunction
{
    public static class Calculate
    {
        [FunctionName("Calculate")]
        [ResponseType(typeof(Answer))]
        [Display(Name = "Basic calculator", Description = "Perform a basic mathematical operation on two numbers")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Function, "post", Route = null)]Equation equation, TraceWriter log)
        {
            log.Info("Calculator starting to calculate");
            log.Info($"Number1: {equation.Number1}");
            log.Info($"Number2: {equation.Number2}");
            log.Info($"Operation: {equation.Operation}");

            Answer answer = new Answer();

            switch (equation.Operation)
            {
                case "+":
                    answer.Result = equation.Number1 + equation.Number2;
                    break;
                case "-":
                    answer.Result = equation.Number1 - equation.Number2;
                    break;
                case "x":
                    answer.Result = equation.Number1 * equation.Number2;
                    break;
                case "÷":
                    answer.Result = equation.Number1 / equation.Number2;
                    break;
                default:
                    answer.Error = "Invalid operation";
                    return await Task.FromResult(new HttpResponseMessage(HttpStatusCode.BadRequest)
                    {
                        Content = new ObjectContent<Answer>(answer, new JsonMediaTypeFormatter())
                    });
            }

            return await Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ObjectContent<Answer>(answer, new JsonMediaTypeFormatter())
            });
        }
    }
}
