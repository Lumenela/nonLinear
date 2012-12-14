require 'json'
class NonLinearController < ApplicationController
  def solve
  end

  def solveEquation
  	render :text =>eval(params[:input]).inspect
  end

  def parseInput(exp)
  	return eval(expression).inspect
	rescue => e
		#return e.to_s + "\n" + e.backtrace.join("\n")
		return "fail"
  	
  end
end
