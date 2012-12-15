require 'json'
class NonLinearController < ApplicationController
  def solve
  end

  def solveEquation
    regexp=Regexp.new('(x|sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh|PI|exp|sqrt)+')
    parse=params[:input].gsub!(regexp,'')
    if parse.eql?(nil)
      validate=0
    else
      validate = parse.scan(/[a-zA-Z]+/).size
    end
    if validate.eql?(0)
      render :text =>eval(params[:input]).inspect
      else
        render :text =>"error, we are input not valid equation"
    end
    
  end

  def parseInput(exp)
  	return eval(expression).inspect
	rescue => e
		#return e.to_s + "\n" + e.backtrace.join("\n")
		return "fail"
  	
  end
end
