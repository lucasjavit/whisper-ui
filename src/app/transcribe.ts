import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../environment';

@Injectable({ providedIn: 'root' })
export class TranscribeService {
  private apiUrl = `${environment.apiUrl}/transcribe`;

  constructor(private http: HttpClient) {}

  uploadAudio(formData: FormData): Observable<string> {
    return this.http.post(this.apiUrl, formData, {
      responseType: 'text'
    });
  }
}
