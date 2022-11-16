//
//  main.swift
//  MyCreditManager
//
//  Created by 김태윤 on 2022/11/16.
//

import Foundation
enum Score:Double{
    case Aplus = 4.5, A = 4, Bplus = 3.5, B = 3, Cplus = 2.5, C = 2, Dplus = 1.5, D = 1, F = 0
    init?(_ raw:String){
        switch raw{
        case "A+": self =  .Aplus
        case "A": self =  .A
        case "B+": self =  .Bplus
        case "B": self = .B
        case "C+": self = .Cplus
        case "C": self = .C
        case "D+": self = .Dplus
        case "D": self = .D
        case "F": self = .F
        default: return nil
        }
    }
}

enum CmdMessage:String{
    enum cmdType {
        case add
        case delete
    }
    case requiredStudentsInput
    //case requireStudentsInput = "할 학생의 입력을 입력해주세요"
    func requireStudentsInput(_ cmdTpye:cmdType)->String{
        switch cmdTpye{
        case .add: return ""
        case .delete: return ""
        }
    }
}
typealias Name = String
typealias Subject = String
typealias SubjectInfos = [Subject:Score]
extension SubjectInfos{
    func getScoreAvg()-> Double{ self.values.map { $0.rawValue}.reduce(0) { $0 + $1 } }
}
typealias Students = [Name : SubjectInfos]
extension Students{
    func isContained(_ name:Name)->Bool{ self[name] != nil }
    mutating func add(_ name: Name){
        self[name] = [:]
    }
    mutating func delete(_ name:Name){
        self[name] = nil
    }

}

func MyCreditManager(){
    var students = Students()
    let functionList = [
    { // append student
        print("추가할 학생의 이름을 입력해주세요.")
        guard let input:Name = readLine() else { return }
        if !students.isContained(input){
            students.add(input)
            print("\(input) 학생을 추가하였습니다.")
        }else{
            print("\(input)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
        }
    },
    { // delete student
        print("제거할 학생의 이름을 입력해주세요.")
        guard let input:Name = readLine() else { return }
        if !students.isContained(input){
            print("\(input)학생을 찾지 못했습니다.")
        }else{
            students.delete(input)
            print("\(input)학생을 삭제하였습니다.")
        }
    },
    {// append score
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+ ,A , F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        guard let input:String = readLine() else {
            print("잘 못 입력했습니다.")
            return
        }
        var inputsIter = input.components(separatedBy: " ").makeIterator()
        guard let name:Name = inputsIter.next(),
              let subject:Subject = inputsIter.next(),
              let rawScore = inputsIter.next() else {
            print("입력이 이상해요 확인해주세요")
            return
        }
        guard students.isContained(name) else { return }
        guard let score:Score = Score(rawScore) else {return}
        students[name]?[subject] = score
    },
    {// delete score
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+ ,A , F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift A+")
        guard let input:String = readLine() else {
            print("잘 못 입력했습니다.")
            return
        }
        var inputsIter = input.components(separatedBy: " ").makeIterator()
        guard let name:Name = inputsIter.next(),
              let subject:Subject = inputsIter.next() else {
            print("입력이 잘 못 되었습니다. 확인해주세요")
            return
        }
        students[name]?.removeValue(forKey: subject)
    },
    {
        guard let name:Name = readLine() else{
            print("잘 못 입력했습니다.")
            return
        }
        guard students.isContained(name) else {return}
        let subjectInfos = students[name]!
        subjectInfos.forEach { (key: Subject, value: Score) in print("\(key):\(value)") }
        print("평점:\(subjectInfos.getScoreAvg())")
    }
    ]
    while let input = readLine(){
        guard input != "X" else {return}
        guard let number:Int = Int(input),(0 <= number && number < functionList.count) else {
            print("잘 못 입력했습니다. 다시 입력하세요.")
            continue
        }
        functionList[number - 1]()
    }
}
//MyCreditManager()
