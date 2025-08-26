// transcribe.ts
import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { TranscribeService } from '../transcribe';

@Component({
  selector: 'app-transcribe',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './transcribe.html',
  styleUrls: ['./transcribe.css']
})
export class TranscribeComponent {
  selectedFile: File | null = null;
  transcription: string = '';  
  progressPercent: number = 0;
  processing: boolean = false;

  constructor(private transcribeService: TranscribeService) {}

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files?.length) {
      this.selectedFile = input.files[0];
      this.transcription = '';
      this.progressPercent = 0;
    }
  }

  onSubmit() {
    if (!this.selectedFile) return;

    this.processing = true;
    const formData = new FormData();
    formData.append('file', this.selectedFile);

    this.transcribeService.uploadAudio(formData).subscribe({
      next: (res: string) => {
        this.transcription = res;
        this.processing = false;
      },
      error: (err) => {
        console.error('Erro na transcrição:', err);
        this.processing = false;
      }
    });
  }

  download(format: 'txt' | 'srt') {
    if (!this.transcription) return;

    let content = this.transcription;

    // se for SRT, converte linhas para o formato simples
    if (format === 'srt') {
      const lines = content.split('\n').filter(l => l.trim() !== '');
      content = lines.map((text, idx) => `${idx+1}\n00:00:00,000 --> 00:00:05,000\n${text}\n`).join('\n');
    }

    const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `transcription.${format}`;
    a.click();
    window.URL.revokeObjectURL(url);
  }
}
