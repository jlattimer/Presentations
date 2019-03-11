using AzureFunctionSwaggerDefinition;
using System.ComponentModel.DataAnnotations;

namespace CalculatorFunction
{
    public class Equation
    {
        [Required]
        [Display(Description = "1st number")]
        [Visibility(ApiVisibility.Important)]
        [Summary("The first number in the equation")]
        public float Number1 { get; set; }

        [Required]
        [Display(Description = "2nd number")]
        [Visibility(ApiVisibility.Important)]
        [Summary("The second number in the equation")]
        public float Number2 { get; set; }


        [Required]
        [Display(Description = "Operation")]
        [Summary("The mathematical operation to perform")]
        [Visibility(ApiVisibility.Important)]
        [StaticValues(new[] { "+", "-", "x", "÷" })]
        public string Operation { get; set; }
    }

    public class Answer
    {
        [Display(Description = "The result of the equation")]
        public float Result { get; set; }

        [Display(Description = "Error details")]
        public string Error { get; set; }
    }
}
