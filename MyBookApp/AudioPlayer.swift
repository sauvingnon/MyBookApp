//
//  AudioPlayer.swift
//  MyBookApp
//
//  Created by Гриша Шкробов on 16.08.2024.
//

import Foundation
import AVFoundation

class AudioPlayer {
    private let audioEngine = AVAudioEngine()
    private let audioPlayerNode = AVAudioPlayerNode()
    private let timePitch = AVAudioUnitTimePitch()
    private var audioFile: AVAudioFile!
    
    private var currentTime: TimeInterval = 0
    private var timer: Timer?
    
    init(audioFileUrl: URL) {
        do {
            audioFile = try AVAudioFile(forReading: audioFileUrl)
            audioEngine.attach(audioPlayerNode)
            audioEngine.attach(timePitch)

            // Подключаем узел времени к узлу плеера
            let format = audioFile.processingFormat
            audioEngine.connect(audioPlayerNode, to: timePitch, format: format)
            audioEngine.connect(timePitch, to: audioEngine.mainMixerNode, format: format)
            audioEngine.prepare()
        } catch {
            print("Ошибка инициализации аудиофайла: \(error)")
        }
    }
    
    
    func getDuration() -> TimeInterval {
        let sampleRate = audioFile.processingFormat.sampleRate
        let durationInSeconds = Double(audioFile.length) / sampleRate
        return durationInSeconds
    }
    
    // Запуск воспроизведения с определенного момента
    func playFromTimeInterval(from time: TimeInterval) {
        
        currentTime = time
        
        if(time < 0){
            print("Время установки воспроизведения не может быть меньше 0.")
            return
        }
        
        let sampleRate = audioFile.processingFormat.sampleRate
        let startFrame = AVAudioFramePosition(time * sampleRate)
        
        // Останавливаем текущий узел перед воспроизведением
        audioPlayerNode.stop()
        
        // Планируем воспроизведение
        audioPlayerNode.scheduleSegment(audioFile,
                                        startingFrame: startFrame,
                                        frameCount: AVAudioFrameCount(audioFile.length - startFrame),
                                        at: nil,
                                        completionHandler: nil)
        
        // Запускаем воспроизведение
        audioPlayerNode.play()
        
    }
    
    func setPlaybackRate(rate: Float) {
        // Устанавливаем скорость воспроизведения (1.0 - нормальная скорость)
        timePitch.rate = rate
    }
    
    // Функция для получения текущего времени воспроизведения
    func getCurrentPlaybackTime() -> TimeInterval {
        // Получаем текущее время воспроизведения
        return currentTime
    }

    
    // Запуск воспроизведения
    func startPlay() {
            guard let audioFile = audioFile else { return }
            audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
            audioEngine.prepare()
            do {
                try audioEngine.start()
                audioPlayerNode.play()
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in 
                    if(self.audioPlayerNode.isPlaying){
                        self.currentTime += Double(1 * self.timePitch.rate)
                    }
                })
            } catch {
                print("Ошибка запуска аудиодвижка: \(error)")
            }
        }

    
    // Продолжить воспроизведение
    func continuePlay(){
        audioPlayerNode.play()
    }
    
    // Пауза
    func pause(){
        audioPlayerNode.pause()
    }
    
    // Остановка воспроизведения
    func stop() {
        audioPlayerNode.stop()
        audioEngine.stop()
    }
}
