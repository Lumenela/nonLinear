require 'json'
class NonLinearController < ApplicationController
  def solve
  end

  @@accuracy = 0.0000000001

  def solveEquation
    equation=String.new(params[:input].to_str)
    validate=validateInput(params[:input])
    if validate.eql?(0)
      input=String.new(mathConcat(equation))
      puts params
      if(params[:method] == "bisection")
        x = calculateBisection(input, Float(params[:lower_bound]), Float(params[:upper_bound]))
      else
        x = calculateSecant(input, Float(params[:lower_bound]), Float(params[:upper_bound]))
      end
      output = {'result'=>'success','solution' => x}.to_json
      render :json => output
    else
        output = {'result'=>'error','solution' => 'error, we are input not valid equation'}.to_json
        render :json => output
    end
    
  end

  def calculateBisection(expression,a,b)
    puts "a=#{a}. b=#{b}, expression=#{expression}"
    xn1 = a
    xn = Float(eval(expression.gsub(/x/,xn1.to_s)).inspect).abs
    while(Float(eval(expression.gsub(/x/,xn.to_s)).inspect).abs >= @@accuracy)
       xn = Float((a+b)/2)
       tmpres = Float(eval(expression.gsub(/x/, xn.to_s)).inspect)
       tmpa = Float(eval(expression.gsub(/x/,a.to_s)).inspect)
      if (tmpres*tmpa < 0)
        b = xn
      else
        a = xn
      end
    end
    return xn
  end


  def calculateSecant(expression, a,b)
    xn0 = a
    xn = b
    yn = Float(eval(expression.gsub(/x/,xn.to_s)).inspect)
    yn0 = Float(eval(expression.gsub(/x/,xn0.to_s)).inspect)
    if(yn0 == yn)
      yn0 = yn + 0.00000000001
    end
    xn1 = xn - yn*(xn-xn0)/(yn-yn0)
    while(Float(eval(expression.gsub(/x/,xn1.to_s)).inspect).abs >= @@accuracy && xn1 >= a && xn1 <= b)
      xn0 = xn
      xn = xn1
      yn = Float(eval(expression.gsub(/x/,xn.to_s)).inspect)
      yn0 = Float(eval(expression.gsub(/x/,xn0.to_s)).inspect)
      xn1 = xn - yn*(xn-xn0)/(yn-yn0)
    end
    return xn1
  end

  def validateInput(input)
    regexp=Regexp.new('((\+|-|\*|\^|\\|x|PI|exp|sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh)(?=\())+')
    puts input
    parse=input.gsub!(regexp,'')
    if parse.eql?(nil)
      parse=input
    end
    return parse.scan(/[a-waA-WyzYZ]+/).size
  end
  
  def mathConcat(input)
    regexp=Regexp.new('((sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh)(?=\())+')
    input = input.gsub(/\^/,"**")
    matcher=input.scan(regexp)
    parse=String.new("")
    matcher.each do|n|
      parse=input.gsub!(n[0],'Math.'+n[0])
    end
    if parse.empty?
      return input
    end
    return parse
  end  

end
